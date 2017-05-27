Date: Sat, 27 May 2017 01:41:35 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170527084135.GA26844@infradead.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
 <1495829844-69341-6-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1495829844-69341-6-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH v2 05/20] randstruct: Whitelist struct
 security_hook_heads cast
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, James Morris <james.l.morris@oracle.com>, Laura Abbott <labbott@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 26, 2017 at 01:17:09PM -0700, Kees Cook wrote:
> The LSM initialization routines walk security_hook_heads as an array
> of struct list_head instead of via names to avoid a ton of needless
> source. Whitelist this to avoid the false positive warning from the
> plugin:

I think this crap just needs to be fixed properly.  If not it almost
defeats the protections as the "security" ops are just about everywhere.
