module hunt.util.TypeUtils;

import hunt.container.Appendable;
import hunt.util.exception;
import hunt.util.string.common;

import std.conv;

class TypeUtils
{
    /**
     * Returns the number of zero bits preceding the highest-order
     * ("leftmost") one-bit in the two's complement binary representation
     * of the specified {@code int} value.  Returns 32 if the
     * specified value has no one-bits in its two's complement representation,
     * in other words if it is equal to zero.
     *
     * <p>Note that this method is closely related to the logarithm base 2.
     * For all positive {@code int} values x:
     * <ul>
     * <li>floor(log<sub>2</sub>(x)) = {@code 31 - numberOfLeadingZeros(x)}
     * <li>ceil(log<sub>2</sub>(x)) = {@code 32 - numberOfLeadingZeros(x - 1)}
     * </ul>
     *
     * @param i the value whose number of leading zeros is to be computed
     * @return the number of zero bits preceding the highest-order
     *     ("leftmost") one-bit in the two's complement binary representation
     *     of the specified {@code int} value, or 32 if the value
     *     is equal to zero.
     * @since 1.5
     */
    public static int numberOfLeadingZeros(int i) {
        // HD, Figure 5-6
        if (i == 0)
            return 32;
        int n = 1;
        if (i >>> 16 == 0) { n += 16; i <<= 16; }
        if (i >>> 24 == 0) { n +=  8; i <<=  8; }
        if (i >>> 28 == 0) { n +=  4; i <<=  4; }
        if (i >>> 30 == 0) { n +=  2; i <<=  2; }
        n -= i >>> 31;
        return n;
    }

    /**
     * @param c An ASCII encoded character 0-9 a-f A-F
     * @return The byte value of the character 0-16.
     */
    public static byte convertHexDigit(byte c) {
        byte b = cast(byte) ((c & 0x1f) + ((c >> 6) * 0x19) - 0x10);
        if (b < 0 || b > 15)
            throw new NumberFormatException("!hex " ~ to!string(c));
        return b;
    }

    /* ------------------------------------------------------------ */

    /**
     * @param c An ASCII encoded character 0-9 a-f A-F
     * @return The byte value of the character 0-16.
     */
    public static int convertHexDigit(char c) {
        int d = ((c & 0x1f) + ((c >> 6) * 0x19) - 0x10);
        if (d < 0 || d > 15)
            throw new NumberFormatException("!hex " ~ to!string(c));
        return d;
    }

    /* ------------------------------------------------------------ */

    /**
     * @param c An ASCII encoded character 0-9 a-f A-F
     * @return The byte value of the character 0-16.
     */
    public static int convertHexDigit(int c) {
        int d = ((c & 0x1f) + ((c >> 6) * 0x19) - 0x10);
        if (d < 0 || d > 15)
            throw new NumberFormatException("!hex " ~ to!string(c));
        return d;
    }

    /* ------------------------------------------------------------ */
    public static void toHex(byte b, Appendable buf) {
        try {
            int d = 0xf & ((0xF0 & b) >> 4);
            buf.append(cast(char) ((d > 9 ? ('A' - 10) : '0') + d));
            d = 0xf & b;
            buf.append(cast(char) ((d > 9 ? ('A' - 10) : '0') + d));
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    /* ------------------------------------------------------------ */
    public static void toHex(int value, Appendable buf) {
        int d = 0xf & ((0xF0000000 & value) >> 28);
        buf.append(cast(char) ((d > 9 ? ('A' - 10) : '0') + d));
        d = 0xf & ((0x0F000000 & value) >> 24);
        buf.append(cast(char) ((d > 9 ? ('A' - 10) : '0') + d));
        d = 0xf & ((0x00F00000 & value) >> 20);
        buf.append(cast(char) ((d > 9 ? ('A' - 10) : '0') + d));
        d = 0xf & ((0x000F0000 & value) >> 16);
        buf.append(cast(char) ((d > 9 ? ('A' - 10) : '0') + d));
        d = 0xf & ((0x0000F000 & value) >> 12);
        buf.append(cast(char) ((d > 9 ? ('A' - 10) : '0') + d));
        d = 0xf & ((0x00000F00 & value) >> 8);
        buf.append(cast(char) ((d > 9 ? ('A' - 10) : '0') + d));
        d = 0xf & ((0x000000F0 & value) >> 4);
        buf.append(cast(char) ((d > 9 ? ('A' - 10) : '0') + d));
        d = 0xf & value;
        buf.append(cast(char) ((d > 9 ? ('A' - 10) : '0') + d));

        // Integer.toString(0, 36);
    }


    /* ------------------------------------------------------------ */
    public static void toHex(long value, Appendable buf) {
        toHex(cast(int) (value >> 32), buf);
        toHex(cast(int) value, buf);
    }
    
        /* ------------------------------------------------------------ */
    public static string toHexString(byte b) {
        return toHexString([b], 0, 1);
    }

    /* ------------------------------------------------------------ */
    public static string toHexString(byte[] b) {
        return toHexString(b, 0, cast(int)b.length);
    }

    
    /* ------------------------------------------------------------ */
    public static string toHexString(byte[] b, int offset, int length) {
        StringBuilder buf = new StringBuilder();
        for (int i = offset; i < offset + length; i++) {
            int bi = 0xff & b[i];
            int c = '0' + (bi / 16) % 16;
            if (c > '9')
                c = 'A' + (c - '0' - 10);
            buf.append(cast(char) c);
            c = '0' + bi % 16;
            if (c > '9')
                c = 'a' + (c - '0' - 10);
            buf.append(cast(char) c);
        }
        return buf.toString();
    }

    
    /* ------------------------------------------------------------ */
    public static byte[] fromHexString(string s) {
        if (s.length % 2 != 0)
            throw new IllegalArgumentException(s);
        byte[] array = new byte[s.length / 2];
        for (int i = 0; i < array.length; i++) {
            int b = to!int(s[i * 2 .. i * 2 + 2], 16);
            array[i] = cast(byte) (0xff & b);
        }
        return array;
    }

    static int parseInt(string s, int offset, int length, int base)
    {
        return to!int(s[offset .. offset+length], base);
    }

}