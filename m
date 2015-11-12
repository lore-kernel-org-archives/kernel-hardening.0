Reply-To: kernel-hardening@lists.openwall.com
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
 <20151107223437.891207864301c26862ae15da@gmail.com>
 <5643436F.3060909@redhat.com> <56448481.5348.383139DB@pageexec.freemail.hu>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <564487E2.7090603@redhat.com>
Date: Thu, 12 Nov 2015 13:36:50 +0100
MIME-Version: 1.0
In-Reply-To: <56448481.5348.383139DB@pageexec.freemail.hu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: Proposal for kernel self protection features
To: pageexec@freemail.hu, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
Cc: Brad Spengler <spender@grsecurity.net>, Greg KH <gregkh@linuxfoundation.org>, Theodore Tso <tytso@google.com>, Josh Triplett <josh@joshtriplett.org>
List-ID: <kernel-hardening.lists.openwall.com>



On 12/11/2015 13:22, PaX Team wrote:
> here's a few existing bugs of interest:
> 
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61311 (the header issue is
> also tracked in https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61176#c18)
> 
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61313
> 
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=41757 (this ship has sailed
> already i guess)
> 
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=46354
> 
> i think fixing the LTO API for plugins (including backports to 4.9/5 at
> least) would be the most important and useful act for the kernel as it'd
> then help convince kernel developers of the merits of adding LTO build
> support to linux itself. IIRC, it was tried before and ran into opposition
> due to perceived lack of usefulness, something that IPA/LTO capable plugins
> could change.

Do you have any pointers on the overflows that can be introduced by the
front-end?  I guess I can also look for hints in the plugin source code.

Paolo
