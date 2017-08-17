Message-ID: <1503003427.1514.6.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Thu, 17 Aug 2017 16:57:07 -0400
In-Reply-To: <1502943802.3986.38.camel@gmail.com>
References: <20170816231458.2299-1-labbott@redhat.com>
	 <20170816231458.2299-3-labbott@redhat.com>
	 <20170817033148.ownsmbdzk2vhupme@thunk.org>
	 <1502943802.3986.38.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCHv3 2/2] extract early boot entropy from the passed cmdline
To: Theodore Ts'o <tytso@mit.edu>, Laura Abbott <labbott@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

> I did say 'external attacker' but it could be made clearer.

Er, s/say/mean to imply/

I do think it will have some local value after Android 8 which should
start shipping in a few days though.

I'll look into having the kernel stash some entropy in pstore soon since
that seems like it could be a great improvement. I'm not sure how often
/ where it should hook into for regularly refreshing it though. Doing it
only on powering down isn't ideal.
