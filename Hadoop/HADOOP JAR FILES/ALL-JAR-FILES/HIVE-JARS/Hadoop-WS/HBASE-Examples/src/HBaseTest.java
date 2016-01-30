// HBaseTest.java
 import java.io.IOException;
 
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.HColumnDescriptor;
import org.apache.hadoop.hbase.HTableDescriptor;
import org.apache.hadoop.hbase.client.HBaseAdmin;
 
public class HBaseTest {
 public static void main(String[] args) {
 // Try to create a Table with 2 column family (Title, Author)
 HTableDescriptor descriptor = new HTableDescriptor("blogposts");
 descriptor.addFamily(new HColumnDescriptor("Title"));
 descriptor.addFamily(new HColumnDescriptor("Author"));
 
try {
 // Create a HBaseAdmin
	

 HBaseConfiguration config = new HBaseConfiguration();
 config.set("hbase.root.dir", "hdfs://192.168.37.136:8020/hbase");
 config.set("hbase.zookeeper.quorum", "192.168.37.136");
 HBaseAdmin admin = new HBaseAdmin(config);
 
// Create table
 admin.createTable(descriptor);
 System.out.println("Table created…");
 } catch (IOException e) {
 System.out.println("IOError: cannot create Table.");
 e.printStackTrace();
 }
 }
 }
