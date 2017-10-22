Date: Sun, 22 Oct 2017 01:25:36 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20171022052536.ptxvnyafk25pakrk@thunk.org>
References: <20171021132446.17567-1-nicolas@belouin.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171021132446.17567-1-nicolas@belouin.fr>
Subject: [kernel-hardening] Re: [PATCH] fs: check for DAC_READ_SEARCH instead of SYS_ADMIN
To: Nicolas Belouin <nicolas@belouin.fr>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Oct 21, 2017 at 03:24:46PM +0200, Nicolas Belouin wrote:
> These checks are meant to prevent leaks or attacks via directory
> traversal, the use of CAP_SYS_ADMIN here is a misuse,
> CAP_DAC_READ_SEARCH being way more appropriate as a process
> with CAP_DAC_READ_SEARCH is entrusted with going trough all directories.
> CAP_SYS_ADMIN is not meant to flag such a process.
> 
> Signed-off-by: Nicolas Belouin <nicolas@belouin.fr>

No.  lookup_dcookie() is a horrid, horrid, hack which is
*spectacularly* dangerous.  We should not be trying to encourage its
use for anything beside its single legacy user, oprofile(8), for which
CAP_SYS_ADMIN is appropriate.

						- Ted
