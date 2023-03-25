class GildedRose

  def initialize(items)
    @items = items
  end
  
  def update_quality
    @items.each do |item|
      case item.name
      when 'Aged Brie'
        update_aged_brie(item)
      when 'Backstage passes to a TAFKAL80ETC concert'
        update_backstage_passes(item)
      when 'Sulfuras, Hand of Ragnaros'
        next
      when 'Conjured item'
        update_conjured(item)
      else
        update_normal_item(item)
      end
    end
  end

  private

  def update_aged_brie(item)
    item.quality += 1
    item.quality = 50 if item.quality > 50
    item.sell_in -= 1
  end

  def update_backstage_passes(item)
    case item.sell_in
    when(6..10)
      item.quality += 2
    when(0..5)
      item.quality += 3
    when(-1)
      item.quality = 0
    else
      item.quality += 1
    end
    
    item.quality = 50 if item.quality > 50
    item.sell_in -= 1
  end

  def update_conjured(item)
    item.quality = [item.quality - 2, 0].max if item.sell_in >= 0
    item.quality = [item.quality - 4, 0].max if item.sell_in < 0
    item.sell_in -= 1
  end

  def update_normal_item(item)
    item.quality = [item.quality - 1, 0].max if item.sell_in >= 0
    item.quality = [item.quality - 2, 0].max if item.sell_in < 0
    item.quality = 0 if item.quality < 0
    item.sell_in -= 1
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
