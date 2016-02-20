Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 20 Feb 2016 10:12:07 -0700
From: David Brown <david.brown@linaro.org>
Message-ID: <20160220171207.GA89634@davidb.org>
References: <20160219182538.GA71114@davidb.org>
 <20160220033353.GA2139@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20160220033353.GA2139@openwall.com>
Subject: Re: [kernel-hardening] Meta: Adding 'List-id' header to
 kernel-hardening posts
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Feb 20, 2016 at 06:33:53AM +0300, Solar Designer wrote:
>David,
>
>On Fri, Feb 19, 2016 at 11:25:38AM -0700, David Brown wrote:
>> I have been unable to locate a contact address for someone who
>> maintains this mailing list,
>
>That would mostly be me.
>
>> so I'm resorting to sending to the full
>> list.  Apologies in advance for the noise this causes.
>
>There is:
>
>kernel-hardening-admin at lists.openwall.com
>
>This address is given in some of ezmlm's help texts.
>
>> I have noticed that this mailing list software inserts a non-standard
>> header to identify the list "Mailing-list:" instead of the RFC2919
>> (https://www.ietf.org/rfc/rfc2919.txt) "List-id" header.  Depending on
>> the particular mail hosting and software, this can make filting on
>> this particular list either difficult or impossible.
>
>As Jason correctly pointed out, we do already have a List-ID header.
>Do you require it to be spelled List-id?  I doubt that trying to match
>a specific case-sensitive spelling is a good idea, since if some client
>software is broken to only look for List-id, some other might only look
>for List-ID.

Sorry, I'd swear I looked for it.  But, no there is no reason to
change the case of the header.

Thanks,
David
