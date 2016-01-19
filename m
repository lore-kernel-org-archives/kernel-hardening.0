Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: jwboyer@gmail.com
In-Reply-To: <569E6ADC.2090306@hurleysoftware.com>
References: <20160119112812.GA10818@mwanda>
	<569E6ADC.2090306@hurleysoftware.com>
Date: Tue, 19 Jan 2016 12:00:57 -0500
Message-ID: <CA+5PVA7C=LDkVNR3v0qxKu8OasJ49fG51aRGwDwA2QOAFGNXhw@mail.gmail.com>
From: Josh Boyer <jwboyer@fedoraproject.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: 2015 kernel CVEs
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg KH <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 19, 2016 at 11:57 AM, Peter Hurley <peter@hurleysoftware.com> wrote:
> On 01/19/2016 03:28 AM, Dan Carpenter wrote:
>> I like to look back over old CVEs to see how we could do better.  Here
>> is the list from 2015.  I got most of this information from the Ubuntu
>> CVE tracker.  Thanks Ubuntu!.  If it doesn't have a hash that means it
>> might not be fixed yet.
>
> [...]
>
>> CVE-2015-4170 cf872776fc84: tty: hang in tty
>
> Makes no sense that this was assigned a CVE.
> I fixed this _2 yrs before_ it was reported and the patch was CC'd stable.

I'm guessing the CVE was assigned because there are distributions that
ship based on kernels earlier than 3.13.  Those distributors need to
verify if they have the fix, etc.

josh
