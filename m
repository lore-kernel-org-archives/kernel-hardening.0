Date: Sat, 27 May 2017 01:42:46 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170527084246.GB26844@infradead.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
 <1495829844-69341-12-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1495829844-69341-12-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH v2 11/20] randstruct: Disable randomization of ACPICA
 structs
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, Laura Abbott <labbott@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 26, 2017 at 01:17:15PM -0700, Kees Cook wrote:
> Since the ACPICA source is maintained externally to the kernel, we can
> neither switch it to designated initializers nor mark it
> __no_randomize_layout. Until ACPICA-upstream changes[1] land to handle the
> designated initialization, explicitly skip it in the plugin.
> 
> [1] https://github.com/acpica/acpica/pull/248

I'd just overried the ACPIA bullshit process and just include these
changes, as they are a major improvement independent of any
reandomization.
