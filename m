Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
References: <20160119112812.GA10818@mwanda>
	<20160119180009.GT17997@ZenIV.linux.org.uk>
Date: Tue, 19 Jan 2016 16:41:55 -0600
In-Reply-To: <20160119180009.GT17997@ZenIV.linux.org.uk> (Al Viro's message of
	"Tue, 19 Jan 2016 18:00:09 +0000")
Message-ID: <87h9i95gzw.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] Re: 2015 kernel CVEs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Tue, Jan 19, 2016 at 02:28:12PM +0300, Dan Carpenter wrote:
>> CVE-2015-4178 820f9f147dcc: fs_pin: uninitialized data
>
> Why is that a CVE?  Affected code is in pin_remove(), which is only
> called from fs_pin ->kill() instances; if one is _ever_ called more
> than once per fs_pin lifetime, we are already FUBAR.  If Eric had
> ever intended to add checks for hlist_unhashed() on those lists,
> such checks never had been added to the tree.  They definitely did not
> exist at the moment when that commit went in.
>
> It got merged mostly on the "it doesn't harm anything and it's a bit
> more tidy that way" basis; if it had ever changed behaviour in any visible
> way, *THEN* we had a real problem and that problem was not fixed by that
> commit, so I would really like to see the details - simply to make sure
> that the damn thing had been eventually fixed.
>
> Eric, could you explain?  And could whoever'd been responsible for
> that CVE describe the process that had lead to its creation?

As best I know this was an issue because someone borked a backport,
and skipped this patch.

As I recall hlist_del_init was needed because in one instance one of the
lists was not used.  Which is actually what it says in the description
of 820f9f147dcc so I will leave it at that.

Eric
