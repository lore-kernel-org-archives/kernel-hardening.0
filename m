Reply-To: kernel-hardening@lists.openwall.com
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
 <CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
 <20151107223437.891207864301c26862ae15da@gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5643436F.3060909@redhat.com>
Date: Wed, 11 Nov 2015 14:32:31 +0100
MIME-Version: 1.0
In-Reply-To: <20151107223437.891207864301c26862ae15da@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: Proposal for kernel self protection features
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
Cc: PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Greg KH <gregkh@linuxfoundation.org>, Theodore Tso <tytso@google.com>, Josh Triplett <josh@joshtriplett.org>
List-ID: <kernel-hardening.lists.openwall.com>



On 07/11/2015 22:34, Emese Revfy wrote:
>>>        * gcc intentional overflow: gcc computes some expressions by overflow
>>>           when it optimizes. Sadly it is doing this in the front end where
>>>           there is no plugin support. Most of these false positives I handle
>>>           from the plugin or sometimes I patch the kernel source code.
>>>           There are some unsolved issues.
>>
>> Has there been any discussion with gcc folks about this problem?
> 
> I never tried it. PaXTeam has some open tickets
> (e.g., https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61311) for a long time so
> because of it I haven't any courage.

I'm not sure I still count as a gcc guy, having averaged at most 1 patch
a year for some time now.  However, I surely would like to know more
about it, and perhaps can look into fixing some of the easier issues.
Do open tickets and CC me (I'm bonzini@gnu.org on the GCC tracker).

Paolo
