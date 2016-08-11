Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <2188666.QKZtt2vNXZ@wuerfel>
References: <1464979224-2085-1-git-send-email-keescook@chromium.org>
 <2760702.46Rp2Juk5b@wuerfel> <20160810230645.GP1041@n2100.armlinux.org.uk> <2188666.QKZtt2vNXZ@wuerfel>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 11 Aug 2016 15:16:50 -0700
Message-ID: <CAGXu5j+RA+fepUEXoqXEBmyhBokQxv0csO=VuzFpHd4Fk4dH4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 2/2] arm: apply more __ro_after_init
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-arch <linux-arch@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Mathias Krause <minipli@googlemail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Aug 11, 2016 at 8:54 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday, August 11, 2016 12:06:45 AM CEST Russell King - ARM Linux wrote:
>> On Wed, Aug 10, 2016 at 09:41:23PM +0200, Arnd Bergmann wrote:
>> > It might be better to start by making the fixed mapping readonly,
>> > as KASLR doesn't protect that one at all, and change the TLS
>> > code accordingly.
>>
>> I think that's impossible, because we gave userspace permission to
>> read 0xffff0ff0 directly without using __kuser_get_tls.  You're
>> talking about potentially breaking userspace.
>>
>> If you disable kuser helpers, then the page becomes read-only and
>> invisible to userspace anyway.  So, everything is being done there
>> which can be done - if you have kuser helpers enabled, then you
>> lose some opportunities for these security improvements.
>
> What I meant was writing to the page through the linear mapping
> rather than the virtual mapping at 0xffff0000 so we can leave that
> one read-only (I did not consider whether that might cause cache
> aliasing problems when reading from the other address).
>
> Your other point is more important though: if one really cares
> about optimizing security here, they probably should disable
> kuser helpers completely anyway.
>
> Kees, is that something you have on your radar already?

It wasn't no. I will add it. :)

-Kees

-- 
Kees Cook
Nexus Security
