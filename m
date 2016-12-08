Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Thu, 08 Dec 2016 15:42:50 +0100
MIME-Version: 1.0
Message-ID: <5849716A.32374.136DAAC@pageexec.freemail.hu>
In-reply-to: <20161206062800.21800-3-andrew.donnellan@au1.ibm.com>
References: <20161206062800.21800-1-andrew.donnellan@au1.ibm.com>, <20161206062800.21800-3-andrew.donnellan@au1.ibm.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH 3/3] powerpc: enable support for GCC plugins
To: linuxppc-dev@lists.ozlabs.org, kernel-hardening@lists.openwall.com, keescook@chromium.org, re.emese@gmail.com, Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, spender@grsecurity.net, mmarek@suse.com
List-ID: <kernel-hardening.lists.openwall.com>

On 6 Dec 2016 at 17:28, Andrew Donnellan wrote:

> Enable support for GCC plugins on powerpc.
> 
> Add an additional version check in gcc-plugins-check to advise users to
> upgrade to gcc 5.2+ on powerpc to avoid issues with header files (gcc <=
> 4.6) or missing copies of rs6000-cpus.def (4.8 to 5.1 on 64-bit targets).

i don't think that this is the right approach. there's a general and a special
issue here, both of which need different handling.

the general problem is to detect problems related to gcc plugin headers and
notify the users about solutions. emitting various messages from a Makefile
is certainly not a scalable approach, just imagine how it will look when the
other 30+ archs begin to add their own special cases... if anything, they
should be documented in Documentation/gcc-plugins.txt (or a new doc if it
grows too big) and the Makefile message should just point at it.

as for the solutions, the general advice should enable the use of otherwise
failing gcc versions instead of forcing updating to new ones (though the
latter is advisable for other reasons but not everyone's in the position to
do so easily). in my experience all one needs to do is manually install the
missing files from the gcc sources (ideally distros would take care of it).

the specific problem addressed here can (and IMHO should) be solved in
another way: remove the inclusion of the offending headers in gcc-common.h
as neither tm.h nor c-common.h are needed by existing plugins. for background,
i created gcc-common.h to simplify plugin development across all supportable
gcc versions i came across over the years, so it follows the 'everything but
the kitchen sink' approach. that isn't necessarily what the kernel and other
projects need so they should just use my version as a basis and fork/simplify
it (even i maintain private forks of the public version).

as for the location of c-common.h, upstream gcc moved it under c-family in
2010 after the release of 4.5, so it should be where gcc-common.h expects
it and i'm not sure how it ended up at its old location for you.

cheers,
 PaX Team
