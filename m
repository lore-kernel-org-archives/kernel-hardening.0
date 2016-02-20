Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 20 Feb 2016 06:33:53 +0300
From: Solar Designer <solar@openwall.com>
Message-ID: <20160220033353.GA2139@openwall.com>
References: <20160219182538.GA71114@davidb.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160219182538.GA71114@davidb.org>
Subject: Re: [kernel-hardening] Meta: Adding 'List-id' header to kernel-hardening posts
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

David,

On Fri, Feb 19, 2016 at 11:25:38AM -0700, David Brown wrote:
> I have been unable to locate a contact address for someone who
> maintains this mailing list,

That would mostly be me.

> so I'm resorting to sending to the full
> list.  Apologies in advance for the noise this causes.

There is:

kernel-hardening-admin at lists.openwall.com

This address is given in some of ezmlm's help texts.

> I have noticed that this mailing list software inserts a non-standard
> header to identify the list "Mailing-list:" instead of the RFC2919
> (https://www.ietf.org/rfc/rfc2919.txt) "List-id" header.  Depending on
> the particular mail hosting and software, this can make filting on
> this particular list either difficult or impossible.

As Jason correctly pointed out, we do already have a List-ID header.
Do you require it to be spelled List-id?  I doubt that trying to match
a specific case-sensitive spelling is a good idea, since if some client
software is broken to only look for List-id, some other might only look
for List-ID.

Alexander
