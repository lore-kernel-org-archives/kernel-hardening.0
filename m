Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <524DF3DA.7060204@zytor.com>
Date: Thu, 03 Oct 2013 15:46:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1380833605-26313-1-git-send-email-keescook@chromium.org> <1380833605-26313-4-git-send-email-keescook@chromium.org> <524DEE6B.2060105@zytor.com> <CAGXu5j+hm8whuGxJ9PBEdxrSwpdH9a-S5-7ReVmb+COyRo9=uw@mail.gmail.com>
In-Reply-To: <CAGXu5j+hm8whuGxJ9PBEdxrSwpdH9a-S5-7ReVmb+COyRo9=uw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 3/7] x86, kaslr: find minimum safe relocation position
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Aaron Durbin <adurbin@google.com>, Eric Northup <digitaleric@google.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@google.com>, Mathias Krause <minipli@googlemail.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 10/03/2013 03:43 PM, Kees Cook wrote:
>> This is highly problematic.  The standard protocol is to hoist the
>> initramfs as high as possible in memory, so this may really unacceptably
>> restrict the available range.
> 
> Doesn't this depend on the boot loader's behavior?

It does, but the recommended (and *required* for compatibility with
older kernels) behavior is to hoist as high as possible.

>> It would be better to treat these the same as reserved regions in the
>> e820 map as far as the address space picking algorithm is concerned.
> 
> Could this be considered a future optimization, or do you feel this is
> required even for this first patch series landing?

Yes, I consider it required because of the above.

	-hpa
