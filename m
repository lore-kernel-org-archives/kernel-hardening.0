Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Thu, 12 Nov 2015 13:22:25 +0100
MIME-Version: 1.0
Message-ID: <56448481.5348.383139DB@pageexec.freemail.hu>
In-reply-to: <5643436F.3060909@redhat.com>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>, <20151107223437.891207864301c26862ae15da@gmail.com>, <5643436F.3060909@redhat.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: Proposal for kernel self protection features
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Brad Spengler <spender@grsecurity.net>, Greg KH <gregkh@linuxfoundation.org>, Theodore Tso <tytso@google.com>, Josh Triplett <josh@joshtriplett.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 11 Nov 2015 at 14:32, Paolo Bonzini wrote:

> I'm not sure I still count as a gcc guy, having averaged at most 1 patch
> a year for some time now.  However, I surely would like to know more
> about it, and perhaps can look into fixing some of the easier issues.
> Do open tickets and CC me (I'm bonzini@gnu.org on the GCC tracker).

here's a few existing bugs of interest:

https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61311 (the header issue is
also tracked in https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61176#c18)

https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61313

https://gcc.gnu.org/bugzilla/show_bug.cgi?id=41757 (this ship has sailed
already i guess)

https://gcc.gnu.org/bugzilla/show_bug.cgi?id=46354

i think fixing the LTO API for plugins (including backports to 4.9/5 at
least) would be the most important and useful act for the kernel as it'd
then help convince kernel developers of the merits of adding LTO build
support to linux itself. IIRC, it was tried before and ran into opposition
due to perceived lack of usefulness, something that IPA/LTO capable plugins
could change.

thanks,
 PaX Team
