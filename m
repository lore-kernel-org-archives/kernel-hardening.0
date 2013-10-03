Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <524DEE6B.2060105@zytor.com>
References: <1380833605-26313-1-git-send-email-keescook@chromium.org>
	<1380833605-26313-4-git-send-email-keescook@chromium.org>
	<524DEE6B.2060105@zytor.com>
Date: Thu, 3 Oct 2013 15:43:11 -0700
Message-ID: <CAGXu5j+hm8whuGxJ9PBEdxrSwpdH9a-S5-7ReVmb+COyRo9=uw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 3/7] x86, kaslr: find minimum safe relocation position
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Aaron Durbin <adurbin@google.com>, Eric Northup <digitaleric@google.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@google.com>, Mathias Krause <minipli@googlemail.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 3, 2013 at 3:23 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/03/2013 01:53 PM, Kees Cook wrote:
>> Examine all the known unsafe areas and avoid them by just raising the
>> minimum relocation position to be past them.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
>> +     /* Minimum location must be above all these regions: */
>
> This is highly problematic.  The standard protocol is to hoist the
> initramfs as high as possible in memory, so this may really unacceptably
> restrict the available range.

Doesn't this depend on the boot loader's behavior?

> It would be better to treat these the same as reserved regions in the
> e820 map as far as the address space picking algorithm is concerned.

Could this be considered a future optimization, or do you feel this is
required even for this first patch series landing?

-Kees

-- 
Kees Cook
Chrome OS Security
