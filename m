Message-Id: <85inkpie9o.fsf@boum.org>
From: intrigeri <intrigeri@boum.org>
References: <CAFwXZv_b3hdEA4xOFKqAVfc4UZEBX=dL9DOY_mDHExsW+Qg6tQ@mail.gmail.com>
Date: Thu, 25 May 2017 09:31:15 +0200
In-Reply-To: <CAFwXZv_b3hdEA4xOFKqAVfc4UZEBX=dL9DOY_mDHExsW+Qg6tQ@mail.gmail.com>
	(hackurx@gmail.com's message of "Wed, 24 May 2017 22:44:48 +0200")
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] Patch for random mac address
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

HacKurx:
> Because this would be useful for distributions like Tails, Subgraph
> OS, Kali Linux and other ...

For what it's worth, it's unlikely that Tails ever uses this unless it
can be controlled at runtime from userspace: we need to give users an
option to disable MAC address randomization, because it breaks network
connectivity in some cases.

Cheers,
-- 
intrigeri
