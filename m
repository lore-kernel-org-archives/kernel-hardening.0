Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: penberg@gmail.com
In-Reply-To: <20110919185518.GA5563@albatros>
References: <20110919144657.GA5928@albatros>
	<CAOJsxLG8gW=BLOptpULsaAEwTravADKbNbXp5e9Wd7xVEfR9AQ@mail.gmail.com>
	<20110919155718.GB16272@albatros>
	<CAOJsxLGZm+npcR0YgXSE2wLC2iXCtzYyCdTDCt1LN=Z28Rm_UA@mail.gmail.com>
	<20110919161837.GA2232@albatros>
	<CAOJsxLE2od0f+6cbL2hA_31CbrqS7AUofx5DT2L9fO_7gxH+PQ@mail.gmail.com>
	<20110919173539.GA3751@albatros>
	<CAOJsxLGc0bwCkDtk2PVe7c155a9wVoDAY0CmYDTLg8_bL4qxqg@mail.gmail.com>
	<20110919175856.GA4282@albatros>
	<CAOJsxLFdNVnW6Faap0UaqZQDQxbA_dEiR2HGdzZtGMJFsVR1WQ@mail.gmail.com>
	<20110919185518.GA5563@albatros>
Date: Mon, 19 Sep 2011 22:33:14 +0300
Message-ID: <CAOJsxLFsmoX777Qui_jBSsv7o0sn2wQ9tY2TeRPyv3ZFvNaRLg@mail.gmail.com>
From: Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Subject: Re: [kernel-hardening] Re: [RFC PATCH 2/2] mm: restrict access to /proc/slabinfo
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, Kees Cook <kees@ubuntu.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Lameter <cl@linux-foundation.org>, Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dan Rosenberg <drosenberg@vsecurity.com>, Theodore Tso <tytso@mit.edu>, Alan Cox <alan@linux.intel.com>, Jesper Juhl <jj@chaosbits.net>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Sep 19, 2011 at 9:55 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> Is there another way to get directly or indirectly the information about
> slabs?

I didn't check closely but there seems to be some filesystem specific
stats under /proc at least. No idea how useful those are as attack
vectors.

I also suspect there are per-module knobs under /proc and /sys that
can be used to get indirect information. Many subsystems have
implemented their own slab wrappers in the past and they keep popping
up every now and then.
