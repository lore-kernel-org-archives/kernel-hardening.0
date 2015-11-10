Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 10 Nov 2015 09:32:50 +0100
From: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Message-ID: <20151110083250.GA1388@chrystal.uk.oracle.com>
References: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
 <n1iirh$q7o$1@ger.gmane.org>
 <CAGXu5j+ponF+a3aoCnLqEVfBy545BsxT4w=8KGikNCb_24ZgyQ@mail.gmail.com>
 <n1khkt$lc7$1@ger.gmane.org>
 <CAGXu5jLuEBUYFNmWOVNvMnTbwyy_+0R1_SywBVhcxkCcm83e-g@mail.gmail.com>
 <26467.1447105487@turing-police.cc.vt.edu>
 <CAEXv5_hcqjdbSKArKRgbqr_A=AR6E0H1Zg3GgL8UGQezg0GeKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEXv5_hcqjdbSKArKRgbqr_A=AR6E0H1Zg3GgL8UGQezg0GeKg@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: Kernel Self Protection Project
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 09, 2015 at 04:55:34PM -0500, David Windsor wrote:
> The problem is cherrypicking these things from the original patchsets.  I'm
> doing that now for PAX_REFCOUNT, and it's proving more difficult than I
> originally expected.

If you're not already using it, you might find easier to work from the
github Mickaël Salaün has set up, something along those lines:

  cd linux-2.6
  git remote add linux-grsecurity https://github.com/linux-scraping/linux-grsecurity.git
  git fetch linux-grsecurity
  git checkout -b grsecurity-pax-refcount-split v4.2.5
  git checkout -p linux-grsecurity -- $(git grep -l PAX_REFCOUNT linux-grsecurity/grsec-4.2)

Which will drop you into a sub-shell where you can pick relevant hunks.
Then you can repeat the last line replacing PAX_REFCOUNT with any new
symbols that you've picked on the way.
  
Quentin
