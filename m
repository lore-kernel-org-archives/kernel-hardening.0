MIME-Version: 1.0
In-Reply-To: <CAH8yC8m1HRNWTE9=NXkUypMupAoMTCfs2L=EEfwtXpBgT5BrZg@mail.gmail.com>
References: <CAHmME9q=AdK7BHQw0+sd4T0HGQce92KXTD+-TTc2s2CXbEHAAA@mail.gmail.com>
 <20170602172616.47qcxav6adq52nmk@thunk.org> <CAHmME9oS_GCRMLf7EF8XBGwjdjohcRz4rzZiWr5ZDUurTj8A7Q@mail.gmail.com>
 <20170602190734.6zll7zc5hr66oacl@thunk.org> <CAHmME9oLHP85ENr5aZgKsTSrxiUWoQ_pfv7C6XYxmcoxPfq3Ew@mail.gmail.com>
 <20170603050433.4xpvloul25s47f2z@thunk.org> <CAHmME9rwKneq0C5GYPSWamGRT0775=-Xw3pyq6uxJXJyyBtr1g@mail.gmail.com>
 <CACXcFmndxSpytsndqeEsOsyB-nyx_xwBAaG1PMRUmof4U-rDMw@mail.gmail.com> <CAH8yC8m1HRNWTE9=NXkUypMupAoMTCfs2L=EEfwtXpBgT5BrZg@mail.gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Sat, 3 Jun 2017 19:55:53 -0400
Message-ID: <CA+DvKQ+B_FBdgPEWSk0L+tPL+ZLTsr56w_TvMD=iE-27+VjidA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: get_random_bytes returns bad randomness
 before seeding is complete
To: Jeffrey Walton <noloader@gmail.com>
Cc: Sandy Harris <sandyinchina@gmail.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Stephan Mueller <smueller@chronox.de>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 3 June 2017 at 18:54, Jeffrey Walton <noloader@gmail.com> wrote:
> On Sat, Jun 3, 2017 at 5:45 PM, Sandy Harris <sandyinchina@gmail.com> wrote:
>> ...
>> Of course this will fail on systems with no high-res timer. Are there
>> still some of those? It might be done in about 1000 times as long on a
>> system that lacks the realtime library's nanosecond timer but has the
>> Posix standard microsecond timer, implying a delay time in the
>> milliseconds. Would that be acceptable in those cases?
>
> A significant portion of the use cases should include mobile devices.
> Device sales outnumbered desktop and server sales several years ago.
>
> Many devices are sensor rich. Even the low-end ones come with
> accelorometers for gaming. A typical one has 3 or 4 sensors, and
> higher-end ones have 7 or 8 sensors. An Evo 4G has 7 of them.
>
> There's no wanting for entropy in many of the use cases. The thing
> that is lacking seems to be taking advantage of it.
>
> Jeff

Hardware random number generator support is also standard on even
low-end mobile devices. The Linux kernel now knows to feed some of the
entropy from those hardware random generators into the kernel CSPRNG
when the driver is initialized but that doesn't happen until fairly
late in the kernel's boot process. The sensors present the same issue.
They aren't available when the kernel starts needing entropy for
features like SSP and KASLR or other early boot uses, unlike
RDRAND/RDSEED on modern x86_64 CPUs.

For userspace, Android's init system blocks until a certain amount of
entropy is obtained from one for the kernel CSPRNG. It's possible for
there to be no hwrandom but I think that's very rare now since the
standard SoCs used everywhere have it available. The device vendor
would probably need to go out of the way to break it. Android also
regularly saves a persistent random seed and restores it on boot. It
also mixes in entropy from the hardware generator regularly since the
kernel didn't know how to do that before, just like it didn't know how
to grab any initial entropy from the hardware generator.

I don't think it's worth worrying too much about mobile. Slimmer
embedded devices that probably don't even save / restore a seed in
many cases or generate keys on first boot before that helps are the
real issue. At least if you're not focused on KASLR and other early
probabilistic kernel exploit mitigations where there's a lack of a way
to get entropy in early boot right now unless the bootloader helps.
