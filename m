Date: Wed, 25 Jan 2017 06:41:49 -0800
From: Matthew Wilcox <willy@infradead.org>
Message-ID: <20170125144149.GA970@bombadil.infradead.org>
References: <20170125141833.GA27658@pjb1027-Latitude-E5410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170125141833.GA27658@pjb1027-Latitude-E5410>
Subject: [kernel-hardening] Re: [PATCH v4] mm: add arch-independent testcases for RODATA
To: Jinbum Park <jinb.park7@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, keescook@chromium.org, arjan@linux.intel.com, akpm@linuxfoundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, labbott@redhat.com, kernel-hardening@lists.openwall.com, mark.rutland@arm.com, kernel-janitors@vger.kernel.org, linux@armlinux.org.uk
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 25, 2017 at 11:18:33PM +0900, Jinbum Park wrote:
> +	/* test 2: write to the variable; this should fault */
> +	/*
> +	 * This must be written in assembly to be able to catch the
> +	 * exception that is supposed to happen in the correct case.
> +	 *
> +	 * So that probe_kernel_write is used to write
> +	 * arch-independent assembly.
> +	 */

This comment makes no sense.  Better to just delete the comment.
