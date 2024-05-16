package com.dbzapp;

import io.debezium.engine.ChangeEvent;
import io.debezium.engine.DebeziumEngine;
import io.debezium.engine.format.Json;

import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

/**
 * Runner class to demonstrate Debezium Embedded engine in a class.
 *
 * @author Sumukh Phalgaonkar, Vaibhav Kushwaha (vkushwaha@yugabyte.com)
 */
public class EngineRunner {
  private CmdLineOpts config;

  public EngineRunner(CmdLineOpts config) {
    this.config = config;
  }

  public void run() throws Exception {
    final Properties props = config.asProperties();

    // Create the engine with this configuration ...
    try (DebeziumEngine<ChangeEvent<String, String>> engine = DebeziumEngine.create(Json.class)
            .using(props)
            .notifying((records, committer) -> {
                for(ChangeEvent<String, String> record: records){
                    System.out.println(record);
                    committer.markProcessed((record));
                }
                committer.markBatchFinished();
            }).build()
        ) {
      // Run the engine asynchronously ...
      System.err.println("Submit engine to executor");
      ExecutorService executor = Executors.newSingleThreadExecutor();
      executor.execute(engine);
      System.err.println("Entering long wait");
      executor.awaitTermination(Long.MAX_VALUE, TimeUnit.DAYS);
    } catch (Exception e) {
      throw e;
    }
  }
}
