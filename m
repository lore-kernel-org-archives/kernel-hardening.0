MIME-Version: 1.0
In-Reply-To: <CAHmME9rwKneq0C5GYPSWamGRT0775=-Xw3pyq6uxJXJyyBtr1g@mail.gmail.com>
References: <CAHmME9q=AdK7BHQw0+sd4T0HGQce92KXTD+-TTc2s2CXbEHAAA@mail.gmail.com>
 <20170602172616.47qcxav6adq52nmk@thunk.org> <CAHmME9oS_GCRMLf7EF8XBGwjdjohcRz4rzZiWr5ZDUurTj8A7Q@mail.gmail.com>
 <20170602190734.6zll7zc5hr66oacl@thunk.org> <CAHmME9oLHP85ENr5aZgKsTSrxiUWoQ_pfv7C6XYxmcoxPfq3Ew@mail.gmail.com>
 <20170603050433.4xpvloul25s47f2z@thunk.org> <CAHmME9rwKneq0C5GYPSWamGRT0775=-Xw3pyq6uxJXJyyBtr1g@mail.gmail.com>
From: Sandy Harris <sandyinchina@gmail.com>
Date: Sat, 3 Jun 2017 17:45:43 -0400
Message-ID: <CACXcFmndxSpytsndqeEsOsyB-nyx_xwBAaG1PMRUmof4U-rDMw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: get_random_bytes returns bad randomness before seeding is complete
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Stephan Mueller <smueller@chronox.de>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Stephan's driver, the HAVEGE system & several others purport to
extract entropy from a series of timer calls. Probably the best
analysis is in the Mcguire et al. paper at
https://static.lwn.net/images/conf/rtlws11/random-hardware.pdf & the
simplest code in my user-space driver at
https://github.com/sandy-harris/maxwell The only kernel-space code I
know of is Stephan's.

If the claim that such calls give entropy is accepted (which I think
it should be) then if we get one bit per call, need 100 or so bits &
space the calls 100 ns apart, loading up a decent chunk of startup
entropy takes about 10,000 ns or 10 microseconds which looks like an
acceptable delay. Can we just do that very early in the boot process?

Of course this will fail on systems with no high-res timer. Are there
still some of those? It might be done in about 1000 times as long on a
system that lacks the realtime library's nanosecond timer but has the
Posix standard microsecond timer, implying a delay time in the
milliseconds. Would that be acceptable in those cases?
