package com.dbzapp;

import java.io.File;
import java.nio.file.Paths;
import java.util.Properties;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.MissingOptionException;
import org.apache.commons.cli.Options;

/**
 * Helper class to parse the command line options.
 *
 * @author Sumukh Phalgaonkar, Vaibhav Kushwaha (vkushwaha@yugabyte.com)
 */
public class CmdLineOpts {
  private final String connectorClass = "io.debezium.connector.yugabytedb.YugabyteDBConnector";
  private String masterAddresses = "127.0.0.1:7100";
  private String hostname = masterAddresses.split(",")[0].split(":")[0];
  private String databasePort = "5433";
  private String streamId;
  private String tableIncludeList;
  private String databaseName = "yugabyte";
  private String databasePassword = "";
  private String databaseUser = "yugabyte";
  private String snapshotMode = "never";
  private String offsetFile = Paths.get(System.getProperty("java.io.tmpdir"), "offset").toString();

  public CmdLineOpts(String[] args){
    Options opts = prepareOptions();
    CommandLine commandLine = parseCommandList(opts, args);
    initialize(commandLine);
  }
  private Options prepareOptions(){
    Options options = new Options();

    options.addOption(null, "master_addresses", true, "Addresses of the master process. Default: " + masterAddresses);
    options.addRequiredOption("s", "stream_id", true, "(Required) DB stream ID");
    options.addRequiredOption("t", "table_include_list", true, "(Required) The table list to poll for in the form <schemaName>.<tableName>");
    options.addOption("d", "database", true, "Database name. Default: " + databaseName);
    options.addOption("h", "hostname", true, "Database Hostname. Default: " + hostname );
    options.addOption("p", "port", true, "Database Port. Default: " + databasePort );
    options.addOption("U", "user", true, "Database user. Default: " + databaseUser );
    options.addOption("W", "password", true, "Database password. Default: " + (databasePassword.equals("")?"<empty>":databasePassword));
    options.addOption(null, "snapshot_mode", true, "Snapshot Mode. Default: " + snapshotMode);
    options.addOption("f", "offset_file", true, "Offset file. Default: " + offsetFile);
    options.addOption( null, "help", false, "Prints help (this screen)");
    return options;
  }
  private CommandLine parseCommandList(Options options, String [] args){

    CommandLineParser parser = new DefaultParser();
    CommandLine commandLine = null;
    try {
      commandLine = parser.parse(options, args);
      if (commandLine.hasOption("help")){
        printHelp(options);
        System.exit(0);
      }
    } catch(MissingOptionException e) {
      printHelp(options);
      System.exit(-1);
    } catch (Exception e) {
      System.out.println(e.getMessage());
      printHelp(options);
      System.exit(-1);
    }
    return commandLine;
  }
  private static void printHelp(Options options){
      HelpFormatter formatter = new HelpFormatter();
      formatter.printHelp(App.class.getName(), options);
  }

  private void initialize(CommandLine cmd) {
    masterAddresses = cmd.getOptionValue("master_addresses", masterAddresses);
    streamId = cmd.getOptionValue( "stream_id");
    tableIncludeList = cmd.getOptionValue( "table_include_list");
    hostname =cmd.getOptionValue( "hostname", masterAddresses.split(",")[0].split(":")[0]);
    databasePort = cmd.getOptionValue( "port", databasePort );
    databaseName = cmd.getOptionValue( "database", databaseName );
    databaseUser = cmd.getOptionValue( "user", databaseUser );
    databasePassword = cmd.getOptionValue( "password", databasePassword );
    snapshotMode = cmd.getOptionValue( "snapshot_mode", snapshotMode );
    offsetFile = cmd.getOptionValue( "offset_file", offsetFile);
  }

  public Properties asProperties() {
    Properties props = new Properties();
    props.setProperty("connector.class", connectorClass);

    props.setProperty("database.streamid", streamId);
    props.setProperty("database.master.addresses", masterAddresses);
    props.setProperty("table.include.list", tableIncludeList);
    props.setProperty("database.hostname", hostname);
    props.setProperty("database.port", databasePort);
    props.setProperty("database.user", databaseUser);
    props.setProperty("database.password", databasePassword);
    props.setProperty("database.dbname", databaseName);
    props.setProperty("database.server.name", "dbserver1");
    props.setProperty("snapshot.mode", snapshotMode);
    props.setProperty("offset.storage", "org.apache.kafka.connect.storage.FileOffsetBackingStore");
    props.setProperty("offset.storage.file.filename", offsetFile);
    props.setProperty("name", "engine");
    props.setProperty("offset.flush.interval.ms", "60000");

    return props;
  }

}
