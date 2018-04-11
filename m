MIME-Version: 1.0
References: <20180411010352.17929-1-labbott@redhat.com>
In-Reply-To: <20180411010352.17929-1-labbott@redhat.com>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date: Wed, 11 Apr 2018 03:44:33 +0000
Message-ID: <CAKwiHFj2Ram90uPVhX+2PvfgcNwcTMfg+M2E3tCOgi4eGyJ6Sg@mail.gmail.com>
Subject: Re: [PATCHv4] gpio: Remove VLA from gpiolib
Content-Type: multipart/alternative; boundary="000000000000aabd4405698a7508"
To: Laura Abbott <labbott@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, Lukas Wunner <lukas@wunner.de>, linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--000000000000aabd4405698a7508
Content-Type: text/plain; charset="UTF-8"

On Wed, Apr 11, 2018, 03:04 Laura Abbott <labbott@redhat.com> wrote:

>                 ret = gpio_chip_get_multiple(chip, mask, bits);
> -               if (ret)
> +               if (ret) {
> +                       /*
> +                        * Go against style and intentionally do the check
> for
> +                        * performance reasons
> +                        */
> +                       if (mask != fastpath)
> +                               kfree(mask);
>

Sorry, but that comment is now both unnecessary and actively wrong. You
can't kfree a stack array, so the check is  required, hence certainly not
against style :-)

--000000000000aabd4405698a7508
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: base64

PGRpdiBkaXI9ImF1dG8iPjxkaXY+PGRpdiBjbGFzcz0iZ21haWxfcXVvdGUiPjxkaXYgZGlyPSJs
dHIiPk9uIFdlZCwgQXByIDExLCAyMDE4LCAwMzowNCBMYXVyYSBBYmJvdHQgJmx0OzxhIGhyZWY9
Im1haWx0bzpsYWJib3R0QHJlZGhhdC5jb20iPmxhYmJvdHRAcmVkaGF0LmNvbTwvYT4mZ3Q7IHdy
b3RlOjwvZGl2PjxibG9ja3F1b3RlIGNsYXNzPSJnbWFpbF9xdW90ZSIgc3R5bGU9Im1hcmdpbjow
IDAgMCAuOGV4O2JvcmRlci1sZWZ0OjFweCAjY2NjIHNvbGlkO3BhZGRpbmctbGVmdDoxZXgiPg0K
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgcmV0ID0gZ3Bpb19jaGlwX2dldF9tdWx0aXBsZShjaGlw
LCBtYXNrLCBiaXRzKTs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBpZiAocmV0KTxicj4N
CivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGlmIChyZXQpIHs8YnI+DQorwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAvKjxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCAqIEdvIGFnYWluc3Qgc3R5bGUgYW5kIGludGVudGlvbmFsbHkgZG8gdGhlIGNoZWNr
IGZvcjxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAqIHBlcmZvcm1h
bmNlIHJlYXNvbnM8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgKi88
YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBpZiAobWFzayAhPSBmYXN0
cGF0aCk8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqBrZnJlZShtYXNrKTs8YnI+PC9ibG9ja3F1b3RlPjwvZGl2PjwvZGl2PjxkaXYgZGlyPSJhdXRv
Ij48YnI+PC9kaXY+PGRpdiBkaXI9ImF1dG8iPlNvcnJ5LCBidXQgdGhhdCBjb21tZW50IGlzIG5v
dyBib3RoIHVubmVjZXNzYXJ5IGFuZCBhY3RpdmVseSB3cm9uZy4gWW91IGNhbiYjMzk7dCBrZnJl
ZSBhIHN0YWNrIGFycmF5LCBzbyB0aGUgY2hlY2sgaXPCoCByZXF1aXJlZCwgaGVuY2UgY2VydGFp
bmx5IG5vdCBhZ2FpbnN0IHN0eWxlIDotKTwvZGl2PjwvZGl2Pg0K
--000000000000aabd4405698a7508--
