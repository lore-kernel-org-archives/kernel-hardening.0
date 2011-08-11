Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Thu, 11 Aug 2011 12:32:59 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110811083259.GA5429@albatros>
References: <20110723162251.GA11485@openwall.com>
 <20110724084200.GB3659@albatros>
 <20110724142710.GB18345@openwall.com>
 <20110725192048.GA21675@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725192048.GA21675@albatros>
Subject: Re: [kernel-hardening] base address for shared libs
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

The problem with ASCII-armor is that it contradicts good ALSR entropy.
E.g. with 12 bits of entropy the maximum library size to fit in low 16
MB is zero bytes.

PaX has 16 bits of entropy, so ASCII-armor would only hurt entropy.

Ubuntu (and most of distros) has 12 bits.  Kees says it makes sense to
enable ASCII-armor for exec-shield only, as e-s already has very poor
entropy.

Upstream has 8 bits for some reason, but AFAICS every distro increase
the limit.


It makes sense to have e.g. 10 bits of entropy for 32-bit environments,
but it would help only for tiny programs (hopefully, most of Owl
programs).  It would not work for any python/GUI/Java, Apache with many
modules, TomCat, etc.

pipacs' position is that exploitation of C-string buffer overflows is
rather rare nowadays, and heap overflows, buffer overflows, math
miscalculation, etc. are much more often => C-string buffer overflow is
not something which worth specific protection.


IMO it makes sense for Owl to have e.g. 10 bits of entropy for libs and
use ASCII-armor.  But it makes very little sense for upstream.  Or even
use 16 bits as PaX does and don't use ASCII-armor at all.  ASCII-armor
has rather limited usage - prevention of ret2libc via exploitation of
C-string buffer overflows.  But it is already included in ASLR, which
does much more.  Probably we should concentrate on more generic things,
like ASLR?

Solar, what do you think?


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
