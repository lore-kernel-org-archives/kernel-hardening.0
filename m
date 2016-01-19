Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
References: <20160119112812.GA10818@mwanda>
Date: Tue, 19 Jan 2016 16:47:32 -0600
In-Reply-To: <20160119112812.GA10818@mwanda> (Dan Carpenter's message of "Tue,
	19 Jan 2016 14:28:12 +0300")
Message-ID: <87ziw14263.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] 2015 kernel CVEs
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Dan Carpenter <dan.carpenter@oracle.com> writes:

> I like to look back over old CVEs to see how we could do better.  Here
> is the list from 2015.  I got most of this information from the Ubuntu
> CVE tracker.  Thanks Ubuntu!.  If it doesn't have a hash that means it
> might not be fixed yet.
>
> CVE-2015-8709 : ptrace: race in user namespaces let's users trace root processes

As this isn't a kernel bug, and is not a race, and no one has even
bothered to see if any userspace processes are this stupid I don't even
think that qualifies as a CVE.

There is room for improvement in this area but I don't see how this
qualifies as a CVE.

So for doing better I recommend a little more vetting and paying
attention before assigning CVEs.

Eric
