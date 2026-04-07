import tkinter as tk
from tkinter import filedialog, simpledialog, messagebox
from PIL import Image, ImageTk, ImageOps
import numpy as np
import cv2
import random

# ==== Fonctions personnalisées ====

def creer_image_noire(h, w):
    return np.zeros((h, w), dtype=np.uint8)

def creer_image_blanche(h, w):
    return np.ones((h, w), dtype=np.uint8) * 255

def creer_image_noir_blanc(h, w):
    return np.random.choice([0, 255], size=(h, w), p=[0.5, 0.5]).astype(np.uint8)

def inverser(img):
    return 255 - img

def flip_horizontal(img):
    return np.fliplr(img)

def fusion_verticale(img1, img2):
    return np.vstack((img1, img2))

def fusion_horizontale(img1, img2):
    return np.hstack((img1, img2))

def image_rgb_aleatoire(h, w):
    return np.random.randint(0, 256, size=(h, w, 3), dtype=np.uint8)

def symetrie(img, axe):
    if axe.lower() == 'horizontal':
        return np.flipud(img)
    else:
        return np.fliplr(img)

def convertir_gris(img):
    if len(img.shape) == 3:
        return cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)
    return img

def calcul_luminance(img):
    gray = convertir_gris(img)
    return np.mean(gray)

def calcul_contraste(img):
    gray = convertir_gris(img)
    return gray.std()

def profondeur_image(img):
    return img.shape[2] if len(img.shape) == 3 else 1

# ==== Interface principale ====

class ImageApp:
    def __init__(self, root):
        self.root = root
        root.title("Menu Principal")
        root.geometry("650x700")

        tk.Label(root, text="Choisissez une option :").pack(pady=5)

        self.options = [
            "1. Image personnalisée",
            "2. Créer une image noire",
            "3. Créer une image blanche",
            "4. Créer une image noir et blanc",
            "5. Calculer la luminance d'une image",
            "6. Calculer le contraste d'une image",
            "7. Trouver la profondeur d'une image",
            "8. Afficher la matrice d'une image",
            "9. Inverser les tons d'une image",
            "10. Symétrie verticale",
            "11. Fusion verticale de deux images",
            "12. Fusion horizontale de deux images",
            "13. Image RGB aléatoire",
            "14. Symétrie personnalisée",
            "15. Convertir en niveaux de gris"
        ]

        self.dropdown_var = tk.StringVar()
        self.dropdown_var.set(self.options[0])
        tk.OptionMenu(root, self.dropdown_var, *self.options).pack(pady=5)

        tk.Button(root, text="Exécuter", command=self.execute_action).pack(pady=5)
        tk.Button(root, text="Quitter", command=root.quit).pack(pady=5)

        # Canvas pour afficher les images
        self.canvas = tk.Canvas(root, width=500, height=450, bg="grey")
        self.canvas.pack(pady=10)

        self.tk_image = None  # pour garder une référence à l'image affichée

    def execute_action(self):
        option = self.dropdown_var.get()

        if option == "1. Image personnalisée":
            file_path = filedialog.askopenfilename(filetypes=[("Images", "*.jpg *.bmp")])
            if not file_path: return
            img = cv2.cvtColor(cv2.imread(file_path), cv2.COLOR_BGR2RGB)
            self.show_image(img)

        elif option == "2. Créer une image noire":
            h = simpledialog.askinteger("Hauteur", "Entrez la hauteur :", initialvalue=256)
            w = simpledialog.askinteger("Largeur", "Entrez la largeur :", initialvalue=256)
            img = creer_image_noire(h, w)
            self.show_image(img)

        elif option == "3. Créer une image blanche":
            h = simpledialog.askinteger("Hauteur", "Entrez la hauteur :", initialvalue=256)
            w = simpledialog.askinteger("Largeur", "Entrez la largeur :", initialvalue=256)
            img = creer_image_blanche(h, w)
            self.show_image(img)

        elif option == "4. Créer une image noir et blanc":
            h = simpledialog.askinteger("Hauteur", "Entrez la hauteur :", initialvalue=256)
            w = simpledialog.askinteger("Largeur", "Entrez la largeur :", initialvalue=256)
            img = creer_image_noir_blanc(h, w)
            img_inv = inverser(img)
            self.show_image(img)
            # Afficher négatif dans une nouvelle fenêtre
            top = tk.Toplevel(self.root)
            top.title("Négatif")
            canvas2 = tk.Canvas(top, width=500, height=450, bg="grey")
            canvas2.pack()
            self.show_image(img_inv, canvas2)

        elif option == "5. Calculer la luminance d'une image":
            file_path = filedialog.askopenfilename(filetypes=[("Images", "*.jpg *.bmp")])
            if not file_path: return
            img = cv2.cvtColor(cv2.imread(file_path), cv2.COLOR_BGR2RGB)
            lum = calcul_luminance(img)
            self.show_image(img)
            messagebox.showinfo("Luminance", f"La luminance est : {lum:.2f}")

        elif option == "6. Calculer le contraste d'une image":
            file_path = filedialog.askopenfilename(filetypes=[("Images", "*.jpg *.bmp")])
            if not file_path: return
            img = cv2.cvtColor(cv2.imread(file_path), cv2.COLOR_BGR2RGB)
            cont = calcul_contraste(img)
            self.show_image(img)
            messagebox.showinfo("Contraste", f"Le contraste est : {cont:.2f}")

        elif option == "7. Trouver la profondeur d'une image":
            file_path = filedialog.askopenfilename(filetypes=[("Images", "*.jpg *.bmp")])
            if not file_path: return
            img = cv2.cvtColor(cv2.imread(file_path), cv2.COLOR_BGR2RGB)
            depth = profondeur_image(img)
            self.show_image(img)
            messagebox.showinfo("Profondeur", f"La profondeur est : {depth}")

        elif option == "9. Inverser les tons d'une image":
            file_path = filedialog.askopenfilename(filetypes=[("Images", "*.jpg *.bmp")])
            if not file_path: return
            img = cv2.cvtColor(cv2.imread(file_path), cv2.COLOR_BGR2RGB)
            img_inv = inverser(img)
            self.show_image(img_inv)

        # Les autres fonctionnalités (fusion, symétrie, RGB aléatoire, etc.) suivent le même principe
        # On peut les ajouter facilement si tu veux

    def show_image(self, img, canvas=None):
        if canvas is None:
            canvas = self.canvas
        if len(img.shape) == 2:  # image grayscale
            img = cv2.cvtColor(img, cv2.COLOR_GRAY2RGB)
        img_pil = Image.fromarray(img)
        img_pil = img_pil.resize((500, 450))
        self.tk_image = ImageTk.PhotoImage(img_pil)
        canvas.create_image(0, 0, anchor="nw", image=self.tk_image)

# ==== Exécution ====
if __name__ == "__main__":
    root = tk.Tk()
    app = ImageApp(root)
    root.mainloop()
