Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
From: Sandy Harris <sandyinchina@gmail.com>
Date: Thu, 16 Jun 2016 13:06:46 -0400
Message-ID: <CACXcFm=VuN+vETYsCo7hJ6j2A=xLEimt8MC_RWQw2czTChnigw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Initialising random(4)
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

The gresecurity patches include code to initiailse the driver's pools
with random data. I have different code to accomplish the same task &
think anyone planning to integrate that part of the gre stuff into the
kernel should also have a look at mine:
https://github.com/sandy-harris/random.gcm/blob/random_gcm/scripts/gen_random.c

I submitted an earlier version as a kernel patch, part of a large &
complex series of proposed patches.
