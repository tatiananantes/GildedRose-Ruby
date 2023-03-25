require File.join(File.dirname(__FILE__), 'gilded_rose')

RSpec.describe GildedRose do

  describe "#update_quality" do
    it "does not change the name" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].name).to eq "foo"
    end

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
end
