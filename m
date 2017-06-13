Date: Mon, 12 Jun 2017 23:34:46 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170613063446.GA12537@infradead.org>
References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>
 <1497286620-15027-6-git-send-email-s.mesoraca16@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1497286620-15027-6-git-send-email-s.mesoraca16@gmail.com>
Subject: [kernel-hardening] Re: [PATCH 05/11] Creation of "check_vmflags" LSM hook
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, linux-mm@kvack.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 12, 2017 at 06:56:54PM +0200, Salvatore Mesoraca wrote:
> Creation of a new LSM hook to check if a given configuration of vmflags,
> for a new memory allocation request, should be allowed or not.
> It's placed in "do_mmap", "do_brk_flags" and "__install_special_mapping".

Please always post the whole series including the users, thanks.
