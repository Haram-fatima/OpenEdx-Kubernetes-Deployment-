from locust import HttpUser, task

class OpenEdXUser(HttpUser):
    @task
    def load_homepage(self):
        self.client.get("/")
    
    @task(3)
    def load_courses(self):
        self.client.get("/courses")
