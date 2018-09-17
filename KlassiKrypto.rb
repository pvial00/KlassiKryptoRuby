class Affine
    def encrypt(words)
        cipher_text = ""
	words.each_byte { |letter|
	    num = letter - 65
	    sub = ((num * 5) + 8) % 26
	    cipher_text += (sub + 65).chr
	}
	return cipher_text
    end
    def decrypt(words)
        plain_text = ""
	words.each_byte { |letter|
	    num = letter - 65
	    sub = (21 * (num - 8)) % 26
	    plain_text += (sub + 65).chr
	}
	return plain_text
    end
end

class Atbash
    @@alphabet = Hash.new
    @@alphabet_rev = Hash.new
    def initialize()
        c = 65
        (65..90).reverse_each { |x|
            @@alphabet[c] = x.chr
	    @@alphabet_rev[x] = c.chr
            c += 1
        } 
    end
    def encrypt(words)
        cipher_text = Array.new
	words.each_byte { |letter|
	    sub = @@alphabet[letter]
	    cipher_text.push(sub)
	}
	return cipher_text.join("")
    end
    def decrypt(words)
        cipher_text = Array.new
	words.each_byte { |letter|
	    sub = @@alphabet_rev[letter]
	    cipher_text.push(sub)
	}
	return cipher_text.join("")
    end
end
class Vigenere
    @@alphabets = Array.new
    def initialize()
	z = 0
        (65..90).each { |x|
	    alphabet = Array.new
	    (65..90).each { |y|
                alphabet.push(y.chr)
	    }
	    if z != 0
	        (1..z).each { |a|
	            shift = alphabet[0]
		    alphabet.delete_at(0)
		    alphabet.push(shift)
	        }
	    end
	    @@alphabets.push(alphabet)
	    z += 1
        }
    end
    def encrypt(data, key)
        cipher_text = Array.new
	keylen = key.length
	for x in 0..(data.length - 1)
	    k = key[x % keylen].ord - 65
	    sub = @@alphabets[k][data[x].ord - 65]
	    cipher_text.push(sub)
	end
	return cipher_text.join("")
    end
    def decrypt(data, key)
        cipher_text = Array.new
	keylen = key.length
	for x in 0..(data.length - 1)
	    k = key[x % keylen].ord - 65
	    sub = @@alphabets[k].index(data[x]) + 65
	    cipher_text.push(sub.chr)
	end
	return cipher_text.join("")
    end
end
class AutoKeyVigenere
    @@alphabets = Array.new
    def initialize()
	z = 0
        (65..90).each { |x|
	    alphabet = Array.new
	    (65..90).each { |y|
                alphabet.push(y.chr)
	    }
	    if z != 0
	        (1..z).each { |a|
	            shift = alphabet[0]
		    alphabet.delete_at(0)
		    alphabet.push(shift)
	        }
	    end
	    @@alphabets.push(alphabet)
	    z += 1
        }
    end
    def encrypt(data, key)
        cipher_text = Array.new
	keylen = key.length
	for x in 0..(data.length - 1)
	    k = key[x].ord - 65
	    sub = @@alphabets[k][data[x].ord - 65]
	    key += data[x]
	    cipher_text.push(sub)
	end
	return cipher_text.join("")
    end
    def decrypt(data, key)
        cipher_text = Array.new
	keylen = key.length
	for x in 0..(data.length - 1)
	    k = key[x].ord - 65
	    sub = @@alphabets[k].index(data[x]) + 65
	    key += data[x]
	    cipher_text.push(sub.chr)
	end
	return cipher_text.join("")
    end
end
class Chaocipher
    def initialize(left=[], right=[])
        if left.length != 26 and right.length != 26
	    @@alpha_sub = ['H', 'X', 'U', 'C', 'Z', 'V', 'A', 'M', 'D', 'S', 'L', 'K', 'P', 'E', 'F', 'J', 'R', 'I', 'G', 'T', 'W', 'O', 'B', 'N', 'Y', 'Q']
	    @@alpha_master = ['P', 'T', 'L', 'N', 'B', 'Q', 'D', 'E', 'O', 'Y', 'S', 'F', 'A', 'V', 'Z', 'K', 'G', 'J', 'R', 'I', 'H', 'W', 'X', 'U', 'M', 'C']
	else
	    @@alpha_sub = left
	    @@alpha_master = right
	end
    end
    def permute_alpha_sub(letter)
        while TRUE
	    step1 = @@alpha_sub[0]
	    @@alpha_sub.delete_at(0)
	    if step1 == letter
	        @@alpha_sub.insert(0, step1)
		break
	    else
	        @@alpha_sub.push(step1)
	    end
	end
	step2 = @@alpha_sub[1]
	@@alpha_sub.delete_at(1)
	@@alpha_sub.insert(12,step2)
    end 
    def permute_alpha_master(letter)
        while TRUE
	    step1 = @@alpha_master[0]
	    @@alpha_master.delete_at(0)
	    if step1 == letter
	        @@alpha_master.insert(0, step1)
		break
	    else
	        @@alpha_master.push(step1)
	    end
	end
	step2 = @@alpha_master[1]
	@@alpha_master.delete_at(1)
	@@alpha_master.insert(12,step2)
    end
    def encrypt(data)
        cipher_text = Array.new
        for i in 0..(data.length - 1)
	    pos = @@alpha_master.index(data[i])
            sub = @@alpha_sub[pos]
            permute_alpha_sub(sub)
            permute_alpha_master(data[i])
            cipher_text.push(sub)
        end
        return cipher_text.join("")
    end	
    def decrypt(data)
        cipher_text = Array.new
        for i in 0..(data.length - 1)
	    pos = @@alpha_sub.index(data[i])
            sub = @@alpha_master[pos]
            permute_alpha_sub(data[i])
            permute_alpha_master(sub)
            cipher_text.push(sub)
        end
        return cipher_text.join("")
    end	
end
