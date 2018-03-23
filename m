MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAKMK7uHJ3NTfu25wPSO7QStRd9pOR3j2tyVp5sa+T5UqUdxu7Q@mail.gmail.com>
References: <20180321154553.GA18454@kroah.com> <20180322065959.GF14155@phenom.ffwll.local>
 <20180322080300.GA28877@kroah.com> <CAKMK7uHJ3NTfu25wPSO7QStRd9pOR3j2tyVp5sa+T5UqUdxu7Q@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 22 Mar 2018 17:14:40 -0700
Message-ID: <CAGXu5j+75ev=w5cmag7Y6mwnvza5Or1pn-s8gWyQTJSH_jHKjg@mail.gmail.com>
Subject: Re: [PATCH] drm: udl: Properly check framebuffer mmap offsets
Content-Type: text/plain; charset="UTF-8"
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, David Airlie <airlied@linux.ie>, dri-devel <dri-devel@lists.freedesktop.org>, Sean Paul <seanpaul@chromium.org>, Cihangir Akturk <cakturk@gmail.com>, Ingo Molnar <mingo@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, Eyal Itkin <eyalit@checkpoint.com>, Daniel Micay <danielmicay@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 22, 2018 at 2:54 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Thu, Mar 22, 2018 at 9:03 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> On Thu, Mar 22, 2018 at 07:59:59AM +0100, Daniel Vetter wrote:
>>> Does anyone working on overflow-proof integers? That would make a lot of
>>> this code so much simpler if we could just ask the compiler to carry the
>>> oferflow bit around for a given expression and then check that and bail
>>> with -EINVAL.
>>
>> That would be nice, but no, I don't think that's part of any C standard
>> work that I have heard of :(
>
> Well we have refcount_t already, stitching something together that
> would work and not suck too badly with performance should be possible.
> But yeah direct compiler support would be better (and would allow
> optimizing the carry flag checks I guess). I kinda hoped Kees&team
> would be working on this eventually.

refcount_t could be used if it happens to match the needed semantics.

> Adding Kees+kernel-hardening, maybe he'll grow fond of this :-)

Yeah, general integer overflow is on the list of things to get fixed
in the kernel. It's a bit of a long road, though.

Clang has -fsanitize=integer (and sub-options) which could be added
for specific object or trees:
https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html#ubsan-checks

GCC seems to only support manual marking of overflow detections:
https://gcc.gnu.org/onlinedocs/gcc/Integer-Overflow-Builtins.html

grsecurity/PaX has a gcc plugin for overflow detection, though it
hasn't been upstreamed and comes with various caveats:
http://forums.grsecurity.net/viewtopic.php?f=7&t=3043
https://github.com/ephox-gcc-plugins/size_overflow

-Kees

-- 
Kees Cook
Pixel Security
