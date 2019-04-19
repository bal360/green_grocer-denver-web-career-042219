require 'pry'

def consolidate_cart(cart)
  consolidated = {}
  cart.each do | hash |
    hash.each do | item, stats |
    if consolidated[item]
      consolidated[item][:count] += 1  
    else
      consolidated[item] = stats
      consolidated[item][:count] = 1
    end
   end
  end
 consolidated
end

def apply_coupons(cart, coupons)
 new_cart = {}
 cart.each do | food, hash |
  coupons.each do | coupon |
    if food == coupon[:item] && hash[:count] >= coupon[:num]
      hash[:count] -= coupon[:num]
      if new_cart["#{food} W/COUPON"]
        new_cart["#{food} W/COUPON"][:count] += 1 
      else 
        new_cart["#{food} W/COUPON"] = 
        { price: coupon[:cost], clearance: hash[:clearance], count: 1 }
      end
     end
    end
   new_cart[food] = hash
  end
 new_cart
end

def apply_clearance(cart)
  clearance_cart = cart
  cart.each do | food, hash |
    if hash[:clearance] 
      clearance_cart[food][:price] = (hash[:price] * 0.8).round(2) 
     else 
      clearance_cart[food][:price] = hash[:price]
    end
  end
 clearance_cart
end

def checkout(cart, coupons)
  cons_cart = consolidate_cart(cart)
  coup_cart = apply_coupons(cons_cart, coupons)
  clear_cart = apply_clearance(coup_cart)

  cart_total = 0
  clear_cart.each do | food, hash |
  cart_total += (hash[:price] * hash[:count])
  end
  cart_total > 100 ? cart_total * 0.9 : cart_total
end
