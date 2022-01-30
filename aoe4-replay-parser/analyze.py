import struct
import sys


def find_all_food_values(contents):
    pos = 0
    should_log = False
    while pos < len(contents):
        if contents[pos:pos+4] == bytes('FOLD', 'ascii') or contents[pos:pos+4] == bytes('DATA', 'ascii'):
            last_pos = pos
            chunk_type = contents[pos:pos+4].decode('ascii')
            pos += 4
            chunk_id = contents[pos:pos+4].decode('ascii')
            pos += 4

            should_log = chunk_id in ["STLI", "STPL", "STPD"]

            chunk_version = struct.unpack('<I', contents[pos:pos+4])[0]
            pos += 4
            chunk_size = struct.unpack('<I', contents[pos:pos+4])[0]
            pos += 4
            chunk_namesize = struct.unpack('<I', contents[pos:pos+4])[0]
            pos += 4
            chunk_name = contents[pos:pos+4]
            pos += 4
            data = contents[pos:pos+chunk_size]

            if should_log:
                print(f'pos={last_pos} parsed chunk type={chunk_type} id={chunk_id} version={chunk_version} size={chunk_size} namesize={chunk_namesize} name={chunk_name}')

            if chunk_id == 'STPD':
                name_length = struct.unpack('<I', contents[pos:pos+4])[0]
                pos += 4
                try:
                    name = contents[pos:pos+2*name_length].decode('utf16')
                    if should_log:
                        print(f'pos={pos} player detected from STDP chunk len={name_length} name={name}')
                    pos += 2*name_length
                except Exception as e:
                    print(f'pos={pos} [warn] could not decode utf8 player name buffer={contents[pos:pos+2*name_length]} error={e}')

        if (contents[pos:pos+4] == bytes('food', 'ascii')):
            value = struct.unpack('<f', contents[pos+4:pos+8])[0]
            if should_log:
                print(f'pos={pos} food = {value}')
            pos += 8

        if (contents[pos:pos+4] == bytes('wood', 'ascii')):
            value = struct.unpack('<f', contents[pos+4:pos+8])[0]
            if should_log:
                print(f'pos={pos} wood = {value}')
            pos += 8

        if (contents[pos:pos+4] == bytes('gold', 'ascii')):
            value = struct.unpack('<f', contents[pos+4:pos+8])[0]
            if should_log:
                print(f'pos={pos} gold = {value}')
            pos += 8

        pos += 1

def main():
    fp = sys.argv[1]
    with open(fp, 'rb') as f:
        contents = f.read()
        find_all_food_values(contents)

if __name__ == '__main__':
    main()
