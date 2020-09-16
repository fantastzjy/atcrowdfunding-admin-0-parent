package com.atguigu.crowd.funding.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Collection;
import java.util.Map;

public class CrowdFundingUtils {

	/**
	 * 判断Map是否有效
	 * 
	 * @param map 待验证的Map
	 * @return true表示有效，false表示无效
	 */
	public static <K, V> boolean mapEffective(Map<K, V> map) {

		return map != null && map.size() > 0;
	}

	/**
	 * 判断集合是否有效
	 * 
	 * @param collection 待验证集合
	 * @return true表示有效，false表示无效
	 */
	public static <E> boolean collectionEffective(Collection<E> collection) {

		return collection != null && collection.size() > 0;
	}

	/**
	 * 判断字符串是否有效
	 * 
	 * @param source 待验证字符串
	 * @return true表示有效，false表示无效
	 */
	public static boolean stringEffective(String source) {

		return source != null && source.length() > 0;
	}

	/**
	 * MD5加密工具方法
	 * 
	 * @param source 明文
	 * @return 密文
	 */
	public static String md5(String source) {

		// 判断传入的明文字符串是否有效
		if (!stringEffective(source)) {

			// 如果检测到明文字符串无效，抛出异常通知方法的调用者
			throw new RuntimeException(CrowdFundingConstant.MESSAGE_CODE_INVALID);
		}

		// 声明StringBuilder待用
		StringBuilder builder = new StringBuilder();

		// 准备字符数组
		char[] characters = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };

		// 指定加密算法
		String algorithm = "MD5";

		try {

			// 执行加密操作的核心对象
			MessageDigest digest = MessageDigest.getInstance(algorithm);

			// 将要加密的明文转换成字节数组形式
			byte[] inputBytes = source.getBytes();

			// 执行加密
			byte[] outputBytes = digest.digest(inputBytes);

			// 遍历outputBytes
			for (int i = 0; i < outputBytes.length; i++) {

				// 获取当前字节数值
				byte b = outputBytes[i];

				// 获取低四位值
				int lowValue = b & 15;

				// 右移四位和15做与运算得到高四位值
				int highValue = (b >> 4) & 15;

				// 以高四位、低四位的值为下标从字符数组中获取对应字符
				char highCharacter = characters[highValue];
				char lowCharacter = characters[lowValue];

				// 拼接
				builder.append(highCharacter).append(lowCharacter);
			}

		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}

		return builder.toString();
	}

}
