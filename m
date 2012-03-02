Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4F500ECB.9090504@zytor.com>
Date: Thu, 01 Mar 2012 16:05:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1330559620-23543-1-git-send-email-wad@chromium.org> <20120301233712.GS3990@outflux.net>
In-Reply-To: <20120301233712.GS3990@outflux.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v12 01/13] sk_run_filter: add support for custom load_pointer
To: Kees Cook <keescook@chromium.org>
Cc: akpm@linux-foundation.org, sfr@canb.auug.org.au, Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de, davem@davemloft.net, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com, corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com
List-ID: <kernel-hardening.lists.openwall.com>

On 03/01/2012 03:37 PM, Kees Cook wrote:
> Hi,
> 
> So far, it looks like everyone who spoke up is satisfied with this patch
> series. Or their MUAs got caught up on a leap-year bug and missed the
> posting. ;)
> 
> Is it time to pull this into -next so more people can feel it? I brought
> Andy Lutomirski's patches forward (needed to bump the prctl values), and
> updated my git tree. If we're ready, here it is in all its request-pull
> format glory:
> 

Acked-by: H. Peter Anvin <hpa@zytor.com>

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
