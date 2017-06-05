Message-ID: <1496627055.21652.4.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Sun, 04 Jun 2017 21:44:15 -0400
In-Reply-To: <1496625669.21652.2.camel@gmail.com>
References: <20170603113007.GA1544@grsecurity.net>
	 <1496498027.22395.1.camel@gmail.com> <20170603142110.GA7578@grsecurity.net>
	 <CA+DvKQ+1BRVgWRcg_anBdf-8cV4=mgu8J9Kf1xVcbZBVePHSsw@mail.gmail.com>
	 <20170604032813.GB25424@grsecurity.net>
	 <1496585753.11788.1.camel@gmail.com>
	 <20170605001225.GA23953@grsecurity.net>
	 <1496625669.21652.2.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Stop the plagiarism
To: Brad Spengler <spender@grsecurity.net>
Cc: kernel-hardening@lists.openwall.com, pageexec@freemail.hu
List-ID: <kernel-hardening.lists.openwall.com>

> migrating it to get_random_long to the write people with a 

s/write/right/

Which is why Jann's submission of a patch earlier didn't land despite it
being really clearly cut, and I really have no idea about any previous
attempts. I have no interest in researching any previous attempts to get
it fixed and guessing at why those never landed. You care who found and
fixed it first, I didn't, so I didn't look into it. That doesn't mean I
wanted credit for fixing it. I would have been happier if Jann, Kees or
Riel had submitted it instead since it's less to deal with.

It needed to be fixed before masking out one of the bytes so I made yet
another fix for it and submitted it.

When you showed up on IRC mad at me, I thought it was about the
__ro_after_init changes which referenced PaX so I couldn't understand
what you were talking about because *I didn't take this change from PaX
like those ones*. Apparently quite hard to understand.
