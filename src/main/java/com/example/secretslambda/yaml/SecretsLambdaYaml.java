package com.example.secretslambda.yaml;

import java.io.File;
import java.io.IOException;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.eclipse.jgit.api.Git;
import org.eclipse.jgit.api.PushCommand;
import org.eclipse.jgit.lib.Constants;
import org.eclipse.jgit.lib.ObjectId;
import org.eclipse.jgit.lib.Repository;
import org.eclipse.jgit.revwalk.RevCommit;
import org.eclipse.jgit.revwalk.RevWalk;
import org.eclipse.jgit.transport.UsernamePasswordCredentialsProvider;
import org.eclipse.jgit.treewalk.TreeWalk;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;
import com.fasterxml.jackson.dataformat.yaml.YAMLGenerator.Feature;

@Component
public class SecretsLambdaYaml implements CommandLineRunner {

    private void rewriteYaml(String repoUrl, String secretName) throws Exception {
        System.out.println("Rewriting secrets.yaml...");
        ObjectMapper objectMapper = new ObjectMapper(new YAMLFactory().disable(Feature.WRITE_DOC_START_MARKER));
        try {
            Map<String, Object> mapper = objectMapper.readValue(new File(repoUrl),
                    new TypeReference<Map<String, Object>>() {
                    });
            Map<String, Object> data = (Map<String, Object>) mapper.get("data");
            data.put(secretName, "este es el username de mi prueba.");
            objectMapper.writeValue(new File(repoUrl), mapper);
            System.out.println("secrets.yaml changed OK");
        } catch (IOException e) {
            throw new Exception(
                    "Rewriting secrets yaml: an IOException occurred when this was assumed to be impossible.");
        }
    }

    @Override
    public void run(String... args) throws Exception {
        System.out.println("Clone repository...");
        File repo = null;
        try {
            repo = new File("src/main/resources/repository");
            Git git = Git.cloneRepository()
                    .setURI("https://github.com/Kompita/mocks.git")
                    .setCredentialsProvider(
                            new UsernamePasswordCredentialsProvider("kompita",
                                    "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"))
                    .setDirectory(repo)
                    .call();
            Repository repository = git.getRepository();
            System.out.println("Get last commit...");
            ObjectId lastCommitId = repository.resolve(Constants.HEAD);
            try (RevWalk revWalk = new RevWalk(repository)) {
                RevCommit commit = revWalk.parseCommit(lastCommitId);
                try (TreeWalk treeWalk = new TreeWalk(repository)) {
                    // treeWalk.addTree(commit.getTree());
                    // treeWalk.setRecursive(true);
                    // treeWalk.addTree(new DirCacheIterator(repository.readDirCache()));
                    // treeWalk.addTree(new FileTreeIterator(repository));
                    // while (treeWalk.next()) {
                    //     if(treeWalk.getPathString().equals("secrets/secrets.yaml")){
                    //         System.out.printf(
                    //             "path: %s, Commit(mode/oid): %s/%s, Index(mode/oid): %s/%s, Workingtree(mode/oid): %s/%s\n",
                    //             treeWalk.getPathString(), treeWalk.getFileMode(0), treeWalk.getObjectId(0),
                    //             treeWalk.getFileMode(1), treeWalk.getObjectId(1),
                    //             treeWalk.getFileMode(2), treeWalk.getObjectId(2));
                    //     }

                        
                    // }
                    System.out.println("sssssss...");
                    // treeWalk.setFilter(PathFilter.create("/secrets.yaml"));
                    // if (!treeWalk.next()) {
                    //     throw new IllegalStateException("Did not find expected secrets.yaml...");
                    // }
                    rewriteYaml("src/main/resources/repository/secrets/secrets.yaml", "username");
                    git.add().addFilepattern(".").call();
                    git.commit().setMessage("Change secrets.yaml with new value").call();
                    System.out.println("Pushing to repository...");
                    PushCommand pushCommand = git.push();
                    pushCommand
                            .setCredentialsProvider(
                                    new UsernamePasswordCredentialsProvider("kompita",
                                            "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"))
                            .setRemote("origin")
                            .add("main")
                            .call();
                }
                System.out.println("Push code successfully...");
                revWalk.dispose();
                git.close();
                FileUtils.deleteDirectory(new File("src/main/resources/repository"));
            }

        } catch (IOException exception) {
            throw new Exception("Upgrading repository: an Exception occurred when this was assumed to be impossible.");
        } finally {
            // System.out.println("1");
            // File[] files = repo.listFiles();
            // for (File file : files) {
            // file.delete();
            // }
            // System.out.println("2");
            // if (repo.delete()) {
            // System.out.println("Repository Deleted");
            // }
        }
    }

}
