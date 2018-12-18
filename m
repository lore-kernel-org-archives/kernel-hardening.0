From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v2 1/2] seq_buf: Make seq_buf_puts() null-terminate the buffer
In-Reply-To: <20181212085057.5add880c@gandalf.local.home>
References: <20181019042109.8064-1-mpe@ellerman.id.au> <87imzzvvlh.fsf@concordia.ellerman.id.au> <20181212084532.093fbf2c@gandalf.local.home> <20181212085057.5add880c@gandalf.local.home>
Date: Tue, 18 Dec 2018 14:58:08 +1100
Message-ID: <87a7l3trjj.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, jannh@google.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Steven Rostedt <rostedt@goodmis.org> writes:
> On Wed, 12 Dec 2018 08:45:32 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
>> On Wed, 12 Dec 2018 22:21:46 +1100
>> Michael Ellerman <mpe@ellerman.id.au> wrote:
>> 
>> > Hi Steve,
>> > 
>> > Friendly ping :)
>> > 
>> > Do you mind picking this one up for 4.21 ?
>> > 
>> >  
>> 
>> Thanks for the reminder, I've been swamped lately. I'll take a look now.
>> 
>
> OK, I applied both to my local queue, and it will reach linux-next
> probably some time at the end of this week or early next week. It needs
> to wait till I'm ready to run my local changes through my test suite.

Sure, no rush. Thanks.

cheers
