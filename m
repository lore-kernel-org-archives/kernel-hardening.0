Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 19 Jan 2016 18:00:09 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20160119180009.GT17997@ZenIV.linux.org.uk>
References: <20160119112812.GA10818@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160119112812.GA10818@mwanda>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: [kernel-hardening] Re: 2015 kernel CVEs
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 19, 2016 at 02:28:12PM +0300, Dan Carpenter wrote:
> CVE-2015-4178 820f9f147dcc: fs_pin: uninitialized data

Why is that a CVE?  Affected code is in pin_remove(), which is only
called from fs_pin ->kill() instances; if one is _ever_ called more
than once per fs_pin lifetime, we are already FUBAR.  If Eric had
ever intended to add checks for hlist_unhashed() on those lists,
such checks never had been added to the tree.  They definitely did not
exist at the moment when that commit went in.

It got merged mostly on the "it doesn't harm anything and it's a bit
more tidy that way" basis; if it had ever changed behaviour in any visible
way, *THEN* we had a real problem and that problem was not fixed by that
commit, so I would really like to see the details - simply to make sure
that the damn thing had been eventually fixed.

Eric, could you explain?  And could whoever'd been responsible for
that CVE describe the process that had lead to its creation?
