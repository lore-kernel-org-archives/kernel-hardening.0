Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Date: Wed, 13 Apr 2016 08:34:31 -0700
Message-ID: <CAGXu5jJ+++wTLk3zV8M6D-aPDnbejw9qOXcznqLRUySsYDiiaQ@mail.gmail.com>
From: Kees Cook <keescook@google.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] ARMv8.0 PAN emulation
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Catalin,

I was curious about where PAN emulation for ARMv8.0 stood? You'd
mentioned[1] that it might be possible to rework the TTBR0 patch to do
what's needed. Is there anyone that has cycles to work on it?

Also, did you ever get an answer about the lowmem boundary?

Thanks,

-Kees

[1] http://www.openwall.com/lists/kernel-hardening/2016/01/13/7

-- 
Kees Cook
Chrome OS & Brillo Security
