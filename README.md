# WorkoutBuddy - Demo: A yet unnamed workout app for matching people to workout together

[![build status](https://gitlab.com/daVinciCEB/unnamed-workout-app/badges/master/build.svg)](https://gitlab.com/daVinciCEB/unnamed-workout-app/commits/master) [![coverage report](https://gitlab.com/daVinciCEB/unnamed-workout-app/badges/master/coverage.svg)](https://gitlab.com/daVinciCEB/unnamed-workout-app/commits/master)

The WorkoutBuddy - Demo is a yet unnamed workout app designed to match people to workout together. Think Tinder, for workout buddies!

**Buddies** *(people looking for workout buddies)* will be able to set up their profiles with preferences about how often they like to work out, and what kind of workouts they enjoy and have experience with, along with a distance radius to show how far away they are willing to look for a workout buddy. Their location will be automatically set from their location services on their phone/tablet/computer (constantly updating as the app is turned on). Once their profiles are set up, the application will show the other workout buddies that are within the radius that they have chosen, along with a "Match Percentage" to show how well the buddy matches their profile. The higher the percentage, the more the buddy matches the user's preferences.

## Development

The application will be built in two separate phases: [Phase 1 (Backend API Development)](#phase-1-backend-api-development) and [Phase 2 (Frontend Application Development)](#phase-2-frontend-application-development)

### Phase 1: Backend API Development

Phase 1 will be developing the Backend API, which will be built using the [Phoenix Framework](http://phoenixframework.org/). The API is being built with speed and scalability in mind, [hence using the Phoenix Framework](http://www.phoenixframework.org/blog/the-road-to-2-million-websocket-connections).

#### API TODOs

- [x] Data Model needs to be set up
- [x] API needs to be created with full JSON REST
- [ ] Users will be able to login and logout
- [ ] Users will have various roles available to them (User, *Premium User*, *Promoted Trainer*)
- [ ] If a user signs in, the API will return other Buddies within the specified radius of the user (#6)
- [ ] Users should be able to like or dislike Buddies (#7)
- [ ] Liked Buddies should go to the users's saved Buddies (#7)
- [ ] Disliked Buddies should be hidden from the user (#7)
- [ ] Each user will have a Match Percentage calculated for each Buddy they see (#8)

### Phase 2: Frontend Application Development

Phase 2 will be developing the native applications for each platform that the application will be used on. The aim is to create an Android application, an iOS application, and a Web Application, so that all phone users can use the platform. Since [Phase 1](#phase-1-backend-api-development) will be developing the full backend, the native applications will only need to query the API, so there should be no heavy lifting on the application side.

#### Frontend TODOs
- [ ] Create Web Application
- [ ] Create iOS Application
- [ ] Create Android Application