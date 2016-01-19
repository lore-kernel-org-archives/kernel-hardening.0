Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 19 Jan 2016 14:56:09 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20160119145609.1238be62@lxorguk.ukuu.org.uk>
In-Reply-To: <20160119112812.GA10818@mwanda>
References: <20160119112812.GA10818@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: 2015 kernel CVEs
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 19 Jan 2016 14:28:12 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> I like to look back over old CVEs to see how we could do better.  Here
> is the list from 2015.  I got most of this information from the Ubuntu
> CVE tracker.  Thanks Ubuntu!.  If it doesn't have a hash that means it
> might not be fixed yet.

That's the list of bugs originating in 2015. You need to go back further
to see some of the fun ones still present (CVE-2013-7445 for example)

> There was only a coupls CVEs that looks like they came from a filesystem
> fuzzer where you create a corrupt filesystems and then try use them.
> There was only one that might have come from a USB fuzzer.  We probably
> should be testing those things better.

There are a bunch of those ignored in Bugzilla for years. I think the
ones for the mainstream file systems have all been tackled but things
like reiserfs don't survive fuzzing too well, which is a problem if your
distribution na=C3=AFvely builds in automounting support for people rooting
your box via USB stick.

Alan
