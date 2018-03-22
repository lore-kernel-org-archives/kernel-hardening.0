MIME-Version: 1.0
Sender: daniel.vetter@ffwll.ch
In-Reply-To: <20180322080300.GA28877@kroah.com>
References: <20180321154553.GA18454@kroah.com> <20180322065959.GF14155@phenom.ffwll.local>
 <20180322080300.GA28877@kroah.com>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Thu, 22 Mar 2018 10:54:47 +0100
Message-ID: <CAKMK7uHJ3NTfu25wPSO7QStRd9pOR3j2tyVp5sa+T5UqUdxu7Q@mail.gmail.com>
Subject: Re: [PATCH] drm: udl: Properly check framebuffer mmap offsets
Content-Type: text/plain; charset="UTF-8"
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Cc: David Airlie <airlied@linux.ie>, dri-devel <dri-devel@lists.freedesktop.org>, Sean Paul <seanpaul@chromium.org>, Cihangir Akturk <cakturk@gmail.com>, Ingo Molnar <mingo@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, Eyal Itkin <eyalit@checkpoint.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 22, 2018 at 9:03 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Mar 22, 2018 at 07:59:59AM +0100, Daniel Vetter wrote:
>> Does anyone working on overflow-proof integers? That would make a lot of
>> this code so much simpler if we could just ask the compiler to carry the
>> oferflow bit around for a given expression and then check that and bail
>> with -EINVAL.
>
> That would be nice, but no, I don't think that's part of any C standard
> work that I have heard of :(

Well we have refcount_t already, stitching something together that
would work and not suck too badly with performance should be possible.
But yeah direct compiler support would be better (and would allow
optimizing the carry flag checks I guess). I kinda hoped Kees&team
would be working on this eventually.

Adding Kees+kernel-hardening, maybe he'll grow fond of this :-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
