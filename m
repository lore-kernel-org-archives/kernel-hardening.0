Message-ID: <1505906284.3490.5.camel@opteya.com>
From: Yann Droneaud <ydroneaud@opteya.com>
Date: Wed, 20 Sep 2017 13:18:04 +0200
In-Reply-To: <20170919171600.GA31441@openwall.com>
References: <20170524155751.424-1-riel@redhat.com>
	 <20170919171600.GA31441@openwall.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] [PATCH v2 0/5] stackprotector: ascii armor
 the stack canary
To: Solar Designer <solar@openwall.com>, riel@redhat.com
Cc: linux-kernel@vger.kernel.org, danielmicay@gmail.com, tytso@mit.edu, keescook@chromium.org, hpa@zytor.com, luto@amacapital.net, mingo@kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, linux-sh@vger.kernel.org, ysato@users.sourceforge.jp, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

Le mardi 19 septembre 2017 à 19:16 +0200, Solar Designer a écrit :
>
> We could put/require a NUL in the middle of the canary,
> but with the full canary being only 64-bit at most that would also
> make some attacks easier.
> 

Are you suggesting to randomly select which byte to set to 0 in each
canary ?

Regards.

-- 
Yann Droneaud
OPTEYA
