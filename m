Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1476040182.2329.72.camel@cvidal.org>
From: Colin Vidal <colin@cvidal.org>
Date: Sun, 09 Oct 2016 21:09:42 +0200
In-Reply-To: <CE954033-54F3-47AE-9788-B26B9CE45401@gmail.com>
References: <1476016472.2329.38.camel@cvidal.org>
	 <CE954033-54F3-47AE-9788-B26B9CE45401@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] self introduction
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi David,

> If you're interested, the HARDENED_ATOMIC team is looking for people
> to help porting the feature to other architectures.  ARM is a
> reasonable candidate for someone new to the project.  I have begun
> this effort myself, but if you'd like to collaborate I'd be
> grateful.

Sounds good!

> It essentially involves porting the original arch-specific features
> from PAX_REFCOUNT into Elena Reshetova's official HARDENED_ATOMIC
> tree, which can be found at
> https://github.com/esreshetova/linux-stable

The link seems broken (https://github.com/esreshetova too). I found
https://github.com/dwindsor/hardened-atomic but it is empty. Did I
miss something/Github filter?

> Please contact me if you have any questions; I'd be glad to help!

I actually have question. :-) As far as I understand, PAX_REFCOUNT [1]
is mainly a x86-only port from PaX project in order to avoid overflow
on atomic_t variable (and avoid use-after-free exploits). I am a
little bit confused about the Elena patch-set HARDENED_ATOMIC [2]. It
is a more mature/recent version of the port, isn't it ?

Thanks!

Colin

[1] https://lwn.net/Articles/668724/
[2] https://lwn.net/Articles/702640/
