const express = require('express');
const passport = require('passport');
const GitHubStrategy = require('passport-github2').Strategy;
const session = require('express-session');

const app = express();

// 세션 설정
app.use(session({ secret: 'yourSecretKey', resave: false, saveUninitialized: true }));

passport.use(new GitHubStrategy({
    clientID: 'YOUR_CLIENT_ID',
    clientSecret: 'YOUR_CLIENT_SECRET',
    callbackURL: 'https://kimproduction.kro.kr/auth/github/callback',
  },
  function(accessToken, refreshToken, profile, done) {
    return done(null, profile);
  }
));

passport.serializeUser(function(user, done) {
  done(null, user);
});

passport.deserializeUser(function(id, done) {
  done(null, id);
});

// GitHub 로그인 라우트
app.get('/auth/github',
  passport.authenticate('github', { scope: ['user:email'] })
);

// GitHub 로그인 콜백 라우트
app.get('/auth/github/callback',
  passport.authenticate('github', { failureRedirect: '/' }),
  function(req, res) {
    res.redirect('/admin');
  }
);

// 관리자 페이지 라우트
app.get('/admin', (req, res) => {
  if (req.isAuthenticated()) {
    res.send(`Hello ${req.user.username}, welcome to the admin page!`);
  } else {
    res.send('<a href="/auth/github">Login with GitHub</a>');
  }
});

app.listen(3000, () => {
  console.log('Server running on http://localhost:3000');
});
