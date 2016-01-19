Reply-To: kernel-hardening@lists.openwall.com
References: <20160119112812.GA10818@mwanda>
From: Peter Hurley <peter@hurleysoftware.com>
Message-ID: <569E6ADC.2090306@hurleysoftware.com>
Date: Tue, 19 Jan 2016 08:57:00 -0800
MIME-Version: 1.0
In-Reply-To: <20160119112812.GA10818@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: 2015 kernel CVEs
To: Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, Greg KH <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 01/19/2016 03:28 AM, Dan Carpenter wrote:
> I like to look back over old CVEs to see how we could do better.  Here
> is the list from 2015.  I got most of this information from the Ubuntu
> CVE tracker.  Thanks Ubuntu!.  If it doesn't have a hash that means it
> might not be fixed yet.

[...]

> CVE-2015-4170 cf872776fc84: tty: hang in tty

Makes no sense that this was assigned a CVE.
I fixed this _2 yrs before_ it was reported and the patch was CC'd stable.

Regards,
Peter Hurley
