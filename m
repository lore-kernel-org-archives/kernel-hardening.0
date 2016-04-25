Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 25 Apr 2016 14:04:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20160425140420.cf51815650e7237c7ed9ffbf@linux-foundation.org>
In-Reply-To: <CAJcbSZGSFOQjxbFETA=Zj6g2pRJeyzMBwPGB691AOoCp7VAr3Q@mail.gmail.com>
References: <1460741159-51752-1-git-send-email-thgarnie@google.com>
	<20160415150026.65abbdd5b2ef741cd070c769@linux-foundation.org>
	<1460759160.19090.50.camel@perches.com>
	<CAJcbSZFoVjdcfKjoajL8mmSfz=BPRALx7=0gw3faE2o-hu1RqQ@mail.gmail.com>
	<CAJcbSZGLABr5xEFeopKTj34bL2P-ss=rChs+AYAP_49r1r0NfA@mail.gmail.com>
	<57153751.7080800@redhat.com>
	<CAJcbSZGSFOQjxbFETA=Zj6g2pRJeyzMBwPGB691AOoCp7VAr3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] mm: SLAB freelist randomization
To: Thomas Garnier <thgarnie@google.com>
Cc: Laura Abbott <labbott@redhat.com>, Joe Perches <joe@perches.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Kees Cook <keescook@chromium.org>, Greg Thelen <gthelen@google.com>, Laura Abbott <labbott@fedoraproject.org>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 18 Apr 2016 12:52:30 -0700 Thomas Garnier <thgarnie@google.com> wrote:

> I agree, if we had a generic way to pass entropy across boots on all
> architecture that would be amazing. I will let the SLAB maintainers to
> decide on requiring CONFIG_ARCH_RANDOM or documenting it.

In our world, requiring that sort of attention from maintainers
requires a pretty active level of pinging, poking and harrassing ;)

I do think that if you stick with get_random_bytes_arch() then it need
a comment explaining why.

And I (still) don't think that get_random_bytes_arch() actually does
what you want - if CONFIG_ARCH_RANDOM isn't implemented then
get_random_bytes_arch() just fails.  IOW your statement "the arch
version that will fallback on get_random_bytes sub API in the worse
case" is a misconception?  There is no fallback.
