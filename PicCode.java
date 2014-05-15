import java.awt.Color;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;

import javax.imageio.ImageIO;

public class PicCode {
	private int width = 52;
	private int height = 52;

	public void encode(String code, String file) {
		BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
		Graphics graphics = image.getGraphics();
		int[] s = str2ascii(str2Unicode(code));
		int z = 0;
		for (int i = 0; i < width; i++) {
			if (z >= s.length) {
				break;
			}
			for (int j = 0; j < height; j++) {
				if (z >= s.length) {
					break;
				}
				Color color = new Color(0, 0, 0);
				if (z < s.length - 2) {
					color = new Color(s[z], s[z + 1], s[z + 2]);
				} else if (z == s.length - 2) {
					color = new Color(s[z], s[z + 1], 0);
				} else if (z == s.length - 1) {
					color = new Color(s[z], 0, 0);
				}
				graphics.setColor(color);
				graphics.drawRect(j, i, 0, 0);
				z = z + 3;
			}
		}
		try {
			ImageIO.write(image, "png", new File(file));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void encodeFromFile(String fromFile, String toFile) {
		StringBuilder sb = new StringBuilder();
		try {
			String encoding = "UTF8";
			File file = new File(fromFile);
			if (file.isFile() && file.exists()) {
				InputStreamReader read = new InputStreamReader(new FileInputStream(file), encoding);
				BufferedReader bufferedReader = new BufferedReader(read);
				String lineTXT = null;
				while ((lineTXT = bufferedReader.readLine()) != null) {
					sb.append(lineTXT);
				}
				read.close();
			} else {
				System.err.println("找不到指定的文件！");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		encode(sb.toString(), toFile);
	}

	public String decode(String file) {
		StringBuilder sb = new StringBuilder();
		try {
			BufferedImage bi = ImageIO.read(new File(file));
			int srcWidth = bi.getHeight();
			int srcHeight = bi.getWidth();
			for (int i = 0; i < srcWidth; i++) {
				for (int j = 0; j < srcHeight; j++) {
					int rgb = bi.getRGB(j, i);
					int R = (rgb & 0x00ff0000) >> 16;
					int G = (rgb & 0x0000ff00) >> 8;
					int B = (rgb & 0x000000ff);
					sb.append((char) R + "" + (char) G + "" + (char) B);
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return sb.toString();
	}

	private int[] str2ascii(String str) {
		char[] chars = str.trim().toCharArray();
		int[] ss = new int[chars.length];
		for (int i = 0; i < chars.length; i++) {
			ss[i] = (int) chars[i];
		}
		return ss;
	}

	private String str2Unicode(String str) {
		char[] arChar = str.toCharArray();
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < arChar.length; i++) {
			int iValue = (int) str.charAt(i);
			if (iValue <= 256) {
				sb.append(str.charAt(i));
			} else {
				sb.append("u" + Integer.toHexString(iValue));
			}
		}
		return sb.toString();
	}

	public static void main(String[] args) {
		PicCode p = new PicCode();
		p.encode("测试中文", "pic.png");
		p.encodeFromFile("text", "pic2.png");
		System.out.println(p.decode("demo.png"));
	}
}
