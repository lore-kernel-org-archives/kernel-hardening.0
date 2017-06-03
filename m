MIME-Version: 1.0
In-Reply-To: <CACXcFmndxSpytsndqeEsOsyB-nyx_xwBAaG1PMRUmof4U-rDMw@mail.gmail.com>
References: <CAHmME9q=AdK7BHQw0+sd4T0HGQce92KXTD+-TTc2s2CXbEHAAA@mail.gmail.com>
 <20170602172616.47qcxav6adq52nmk@thunk.org> <CAHmME9oS_GCRMLf7EF8XBGwjdjohcRz4rzZiWr5ZDUurTj8A7Q@mail.gmail.com>
 <20170602190734.6zll7zc5hr66oacl@thunk.org> <CAHmME9oLHP85ENr5aZgKsTSrxiUWoQ_pfv7C6XYxmcoxPfq3Ew@mail.gmail.com>
 <20170603050433.4xpvloul25s47f2z@thunk.org> <CAHmME9rwKneq0C5GYPSWamGRT0775=-Xw3pyq6uxJXJyyBtr1g@mail.gmail.com>
 <CACXcFmndxSpytsndqeEsOsyB-nyx_xwBAaG1PMRUmof4U-rDMw@mail.gmail.com>
From: Jeffrey Walton <noloader@gmail.com>
Date: Sat, 3 Jun 2017 18:54:39 -0400
Message-ID: <CAH8yC8m1HRNWTE9=NXkUypMupAoMTCfs2L=EEfwtXpBgT5BrZg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: get_random_bytes returns bad randomness before seeding is complete
To: Sandy Harris <sandyinchina@gmail.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Stephan Mueller <smueller@chronox.de>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jun 3, 2017 at 5:45 PM, Sandy Harris <sandyinchina@gmail.com> wrote:
> ...
> Of course this will fail on systems with no high-res timer. Are there
> still some of those? It might be done in about 1000 times as long on a
> system that lacks the realtime library's nanosecond timer but has the
> Posix standard microsecond timer, implying a delay time in the
> milliseconds. Would that be acceptable in those cases?

A significant portion of the use cases should include mobile devices.
Device sales outnumbered desktop and server sales several years ago.

Many devices are sensor rich. Even the low-end ones come with
accelorometers for gaming. A typical one has 3 or 4 sensors, and
higher-end ones have 7 or 8 sensors. An Evo 4G has 7 of them.

There's no wanting for entropy in many of the use cases. The thing
that is lacking seems to be taking advantage of it.

Jeff
