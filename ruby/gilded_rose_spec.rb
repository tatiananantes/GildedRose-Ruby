require File.join(File.dirname(__FILE__), 'gilded_rose')

RSpec.describe GildedRose do

  describe '#update_quality' do
    it 'does not change the name' do
      items = [Item.new('foo', 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items.first.name).to eq 'foo'
    end

    context 'decreases quality of items' do
      it 'decreases quality x1 for normal items' do
        item = Item.new('Normal item', 1, 1)
        gilded_rose = GildedRose.new([item])
        items = gilded_rose.update_quality
        expect(items.first.quality).to eq(0) 
      end

      it 'decreases quality x2 for conjured items' do
        conjured_item = Item.new('Conjured item', 1, 2)
        gilded_rose = GildedRose.new([conjured_item])
        items = gilded_rose.update_quality
        expect(items.first.quality).to eq(0) 
      end
    end

    context 'the quality of an item is never negative' do
      it 'does not decrease quality lower than zero' do
        item = Item.new('Normal item', 1, 0)
        gilded_rose = GildedRose.new([item])
        items = gilded_rose.update_quality
        expect(items.first.quality).to eq(0) 
      end

      it 'does not decrease quality lower than zero' do
        conjured_item = Item.new('Conjured item', 1, 1)
        gilded_rose = GildedRose.new([conjured_item])
        items = gilded_rose.update_quality
        expect(items.first.quality).to eq(0) 
      end
    end

    context 'when the sell by date has passed' do
      it 'degrades the quality of a normal item twice as fast' do
        items = [Item.new('Normal item', -1, 10)]
        gilded_rose = GildedRose.new(items)
        gilded_rose.update_quality()
        expect(items.first.quality).to eq(8)
      end
      it 'degrades the quality of a conjured item twice as fast' do
        conjured_items = [Item.new('Conjured item', -1, 10)]
        gilded_rose = GildedRose.new(conjured_items)
        gilded_rose.update_quality()
        expect(conjured_items.first.quality).to eq(6)
      end
    end

    it 'increases the quality of Aged Brie the older it gets' do
      aged_brie_items = [Item.new('Aged Brie', 10, 20)]
      gilded_rose = GildedRose.new(aged_brie_items)
      gilded_rose.update_quality()
      expect(aged_brie_items.first.quality).to eq(21)
    end

    it 'never sets the quality of an item above 50' do
      items = [Item.new('Normal Item', 10, 50), Item.new('Aged Brie', 10, 50), Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 50)]
      gilded_rose = GildedRose.new(items)
      gilded_rose.update_quality()
      items.each do |item|
        expect(item.quality).to be <= 50
      end
    end

    it 'never changes sell_in or quality for Sulfuras' do
      sulfuras = Item.new('Sulfuras, Hand of Ragnaros', 10, 80)
      gilded_rose = GildedRose.new([sulfuras])
      gilded_rose.update_quality()
      expect(sulfuras.sell_in).to eq(10)
      expect(sulfuras.quality).to eq(80)
    end
    
    it 'increases the quality of "Backstage passes" as the sell-in approaches and drops to 0 after the concert' do
      backstage_passes = Item.new('Backstage passes to a TAFKAL80ETC concert', 12, 10)
      gilded_rose = GildedRose.new([backstage_passes])
    
      # Before 10 days to the concert
      gilded_rose.update_quality()
      expect(backstage_passes.quality).to eq(11)
    
      # Within 10 days to the concert
      2.times { gilded_rose.update_quality() }
      expect(backstage_passes.quality).to eq(14)
    
      # Within 5 days to the concert
      4.times { gilded_rose.update_quality() }
      expect(backstage_passes.quality).to eq(22)

      # Within 4 days to the concert
      gilded_rose.update_quality()
      expect(backstage_passes.quality).to eq(25)
    
      # On the day of the concert
      5.times { gilded_rose.update_quality() }
      expect(backstage_passes.quality).to eq(40)
    
      # After the concert
      gilded_rose.update_quality()
      expect(backstage_passes.quality).to eq(0)
    end
    
  end
end
