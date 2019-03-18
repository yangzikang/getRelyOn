import java.io.*;
import java.net.URI;
import java.util.HashMap;
import java.util.Map;

class Translate {
	public static Map<String, String> baseMap = new HashMap<>();
	public static Map<String, String> bussnessMap = new HashMap<>();
	public static String relativePath = "";

	public static void main(String[] args) {
		relativePath = args[0];
		translateToMap(new File(URI.create("file://" + relativePath + "/功能模块表格")), baseMap);
		translateToMap(new File(URI.create("file://" + relativePath + "/业务模块表格")), bussnessMap);
		renameFileContent(new File(URI.create("file://" + relativePath + "/revert")));
		renameFileName(new File(URI.create("file://" + relativePath + "/revert")));
	}

	public static void translateToMap(File file, Map<String, String> map) {
		FileInputStream fileInputStream;
		try {
			fileInputStream = new FileInputStream(file);
			@SuppressWarnings("resource")
			BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(fileInputStream));
			String line = null;
			while ((line = bufferedReader.readLine()) != null) {
				System.out.println(line);
				String arrs[] = line.split(" ");
				map.put(arrs[1], arrs[0]);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public static void renameFileName(File dirName) {
		try {
			File[] files = dirName.listFiles();
			for (File file : files) {
				if (baseMap.containsKey(file.getName())) {
					String newFileName = "功能模块_" + baseMap.get(file.getName());
					String newFilepath = file.getParent() + File.separator + newFileName;
					File newFile = new File(newFilepath);
					file.renameTo(newFile);
				} else if (bussnessMap.containsKey(file.getName())) {
					String newFileName = "业务模块_" + bussnessMap.get(file.getName());
					String newFilepath = file.getParent() + File.separator + newFileName;
					File newFile = new File(newFilepath);
					file.renameTo(newFile);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void renameFileContent(File dirName) {
		try {
			File[] files = dirName.listFiles();
			for (File file : files) {
				FileInputStream fileInputStream = new FileInputStream(file);
				BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(fileInputStream));
				String line = null;
				StringBuilder sb = new StringBuilder("");
				while ((line = bufferedReader.readLine()) != null) {
					if (baseMap.containsKey(line)) {
						sb.append("功能模块_" + baseMap.get(line) + "\n");
					} else if (bussnessMap.containsKey(line)) {
						sb.append("业务模块_" + bussnessMap.get(line) + "\n");
					} else {
						sb.append(line + "\n");
					}
				}
				fileInputStream.close();
				bufferedReader.close();

				FileWriter fwriter = null;
				fwriter = new FileWriter(file);
				fwriter.write(sb.toString());
				fwriter.flush();
				fwriter.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}